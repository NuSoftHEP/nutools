#undef NOVA 
#define LARSOFT 1
// This was NOvA's MixSimEvents_module.cc
//   rename to MixGenieEvents_module.cc avoid confusion
// unless NOVA is enabled this will only mix MCTruth/MCFlux/GTruth
// and not sim::FLSHit and sim::Particle

//
// Read zero or more events from an art event-data file and mix them
// into the current event.  Part of the job is to update art::Ptr
// objects to point into the mixed collections.  The simb::MCTruth
// simb::MCFlux objects are always read and mixed.  Conditionally 
// compiled code allows for the NOvA-specific sim::Particle and
// sim::FLSHitList objects, to be mixed (LArSoft can use the existing
// code as a template for their equivalents).  Also the mapping
// art::Assn<simb::MCTruth,sim::Particle> needs to be handled.
//
// $MixGenieEvents_module.cc,v 1.1 2012/06/05 19:35:38 rhatcher Exp $
// $Author: rhatcher $
// $Date: 2012-10-07 05:33:26 $
//
// This code is based on Rob Kutschke's mu2e code:
//   MixMCEvents_module.cc,v 1.10 2012/02/13 20:56:22 kutschke Exp
//   Author: kutschke
//   Date: 2012/02/13 20:56:22
// The name was changed to avoid any confusion.
//
// Notes:
//
// 1) The class name of the module class is MixGenieEvents.  Therefore an 
//    fcl file that uses this module must contain the parameter:
//        module_type: MixGenieEvents
//
// 2) There are two parts to mixing:
//      1) The inner details of root peristency and art bookkeeping.
//      2) High level ideas about how to event-mix various data products.
//    The goal of the design is to separate the code into parts that
//    require expert knowledge of 1 but not 2 and other parts that
//    require expert knowledge of 2 but not 1.
//
//    The solution is that the art developers wrote "the one true
//    mixing module" which knows all about 1 and nothing about 2.
//    This requires that mu2e must write a set of callback functions,
//    called by the one true mixing module, to do all of the work from
//    part 2.
//
//    The rejected alternative was to have mu2e write the module class
//    and provide a toolkit to hide the details of 1). It was judged
//    that even an optimally designed toolkit would still require that
//    the mu2e developer have much too much knowledge of 1).
//
//    The technology by which the callbacks are implemented is this.
//    The "one true mixing module" is a class template.  The template
//    argument of the class template is a so called "mixing detail"
//    class that is written by mu2e: all of the callbacks are member
//    functions of the mixing detail class.  Some of the callbacks are
//    "just there" - the template knows to look for them.  Other
//    callbacks must be registered with the template, which is done in
//    the c'tor of the mixing detail class using calls to
//    MixHelper::declareMixOp.
//
//    If we want to mix detector events from one file and rock or
//    cosmic events from another file, then the .fcl file needs to
//    instantiate two (or more) instances of the same mixing module,
//    giving them different input files and, presumably, different
//    Poisson means.
//
//    If we need to do two different kinds of mixing, we write two
//    different mixing detail classses and instantiate the template
//    twice, once with each detail class.  Each instantiation needs to
//    be in a separate xxx_module.cc file.
//
// 3) For additional documentation, see:
//      test/Integration/MixAnalyzer_module.cc
//      art/Framework/Core/PtrRemapper.h
//      art/Persistency/Common/CollectionUtilities.h
//
//    The first of these is in art test suite available at:
//      https://cdcvs.fnal.gov/redmine/projects/art/repository/revisions/master/show/test/Integration
//
//    The other two are available at $ART_INC or in the code browser:
//      https://cdcvs.fnal.gov/redmine/projects/art/repository/revisions/master/show/art
//
// 4) The order in which the callbacks are called is:
//       - startEvent()
//       - nSecondaries();
//       - processEventIDs()
//       - methods registered with MixHelper::declareMixOp, 
//         in order of declaration.
//       - finalizeEvent()
//
// 5) In this module, the order of declareMixOp methods is:
//      - mixMCTruth
//      - mixMCFlux
//      - mixParticle
//      - mixFLSHitList
//
// 6) The mixOp methods return a bool.  If this is true, the output
//    product will be added to the event.  If it is false, the output
//    product will not be added to the event.
//
// 7) The art::MixFilter template requires that the arguments of a 
//    mixOp methods is:
//      ( std::vector< T const*> const&, T&, art::PtrRemapper const& )
//    The second argument is not std::vector<T>&, just T&.  This might
//    cause problems if T is not a collection type.  The one case in
//    which we encounter this is with the StatusG4 objects but those
//    objects end up in the MixingSummary, so there is no real
//    problem.
//
// 8) Todo:
//    When art v1_0_0 is available
//     - add extra argument to the mixOp for StatusG4.
//     - Get scale factor from the event.
//

// nusoft and NOVA includes
namespace evgb { unsigned int GetRandomNumberSeed(); }
#ifndef ART_V1
  #include "nusimdata/SimulationBase/MCTruth.h"
  #include "nusimdata/SimulationBase/MCFlux.h"
  #include "nusimdata/SimulationBase/GTruth.h"
  #include "nutools/EventGeneratorBase/evgenbase.h"
#else
  #include "SimulationBase/MCTruth.h"
  #include "SimulationBase/MCFlux.h"
  #include "SimulationBase/GTruth.h"
  #include "EventGeneratorBase/evgenbase.h"
#endif

#ifdef NOVA
  #include "Simulation/Particle.h"
  #include "Simulation/FLSHitList.h"
//#include "Utilities/AssociationUtil.h"
#endif

// Includes from art
#include "art/Framework/Principal/Event.h"
#include "art/Framework/Core/ModuleMacros.h"
#include "art/Framework/Modules/MixFilter.h"
#include "art/Framework/IO/ProductMix/MixHelper.h"
#include "art/Framework/Core/PtrRemapper.h"
#include "art/Framework/Services/Optional/TFileService.h"
#include "art/Persistency/Common/CollectionUtilities.h"

#ifndef ART_V1
  #include "canvas/Utilities/InputTag.h"
#else
  #include "art/Utilities/InputTag.h"
#endif

// Includes from the art tool chain.
#include "cetlib/map_vector.h"

// ROOT includes
#include "TH1F.h"

// Other third party includes
#include "boost/noncopyable.hpp"
#include "CLHEP/Random/RandPoissonQ.h"

// C++ includes
#include <vector>
#include <memory>

using namespace std;

namespace sim {

  // Forward declare the classs we will write later in this file
  class MixGenieEventsDetail;

  // This is the module class.
  typedef art::MixFilter<MixGenieEventsDetail> MixGenieEvents;

}

// Now declare the class.
//
//*********************MixGenieEventsDetail  Class**************************************
//
class sim::MixGenieEventsDetail : private boost::noncopyable {

public:

  MixGenieEventsDetail(fhicl::ParameterSet const &p,
                     art::MixHelper &helper);


  void startEvent(art::Event const &e);        //Called at the start of each event     
  size_t nSecondaries();  // Return number of events to be read from the input file for this primary event
  void processEventIDs(art::EventIDSequence const &seq);   // Save the event Ids taken from the mix-in input file.
  void finalizeEvent(art::Event &e);   // The last method called for each event.

  // Mixing functions:
  typedef std::vector< simb::MCTruth > MCTruthVector;
  bool mixMCTruth(std::vector< MCTruthVector const * > const& in, 
                  MCTruthVector&                              out,
                  art::PtrRemapper const & );

  typedef std::vector< simb::MCFlux > MCFluxVector;
  bool mixMCFlux(std::vector< MCFluxVector const * > const& in, 
                 MCFluxVector&                              out,
                 art::PtrRemapper const & );

#if defined(NOVA) || defined(LARSOFT)
  typedef std::vector< simb::GTruth > GTruthVector;
  bool mixGTruth(std::vector< GTruthVector const * > const& in, 
                       GTruthVector&                              out,
                       art::PtrRemapper const & );
#endif

#ifdef NOVA
  typedef std::vector< sim::FLSHitList > FLSHitListVector;
  bool mixFLSHitList(std::vector< FLSHitListVector const * > const& in, 
                     FLSHitListVector&                              out,
                     art::PtrRemapper const & );

//std::vector<sim::Particle>
  typedef std::vector< sim::Particle > ParticleVector;
  bool mixParticle(std::vector< ParticleVector const * > const& in,
                       ParticleVector&                              out,
                       art::PtrRemapper const & );
#endif

private:

  // Run-time configurable members.

  double mean_;   // The number of mix-in events to choose on each event.
  
  std::string genModuleLabel_;   // Module labels of the producer that made the GenParticles
  std::string g4ModuleLabel_;
 
  bool secondCollectionIsCosmic_;
  bool doPointTrajectories_; 

  // Only one of the following is meaningful in any instance of this class
  // If mean_ >0 then the poisson distribution is valid; else n0_ is valid.

  //deprecated//auto_ptr<CLHEP::RandPoissonQ> poisson_;
  CLHEP::RandPoissonQ* poisson_;  // this will leak for now
  unsigned int n0_;

  std::string mode_;

  // Non-run-time configurable members.
 
  int evtCount_;
  int stepCollectionCount_;

  TH1F* hNEvents_;   // Histogram to record the distribution of generated events.
  size_t actual_;    // The number of mix-in events chosen on this event.

  // The offsets returned from flattening the GenParticle and
  // SimParticle collections.  These are needed in Ptr remapping  operations.
  std::vector<size_t> genOffsets_;
  std::vector<size_t> simOffsets_;

};

// Some helper classes used only within this file.

namespace {

  void PoissonBins(double mean, double width,
                   int& nbins, double& xlow, double& xhigh) {
    if ( mean<0) {
      int n0 = static_cast<int>(std::floor(std::abs(mean)));
      nbins = 3;
      xlow  = n0 - 1;
      xhigh = n0 + 1;
    } else if ( mean < 2 ) {
      nbins = 10;
      xlow  = 0.;
      xhigh = 10.;
    } else if ( mean < 25 ) {
      nbins = 50;
      xlow  = 0.;
      xhigh = 50.;
    } else if ( mean < 60 ) {
      nbins = 100;
      xlow  = 0.;
      xhigh = 100.;
    } else {
      int xl = static_cast<int>(std::floor(mean-width*std::sqrt(mean)));
      int xh = static_cast<int>(std::ceil(mean+width*std::sqrt(mean)));
      nbins = xh-xl;
      xlow  = xl;
      xhigh = xh;
      if ( nbins > 100 ) {
        nbins = 100;
      }
    }
    return;
  }

  // When one or more input collections is mixed into one output
  // collection, this class describes the range in the output collection that
  // corresponds to one input collection.
 
 struct StepInfo {
    StepInfo( size_t aindex, size_t asize, size_t alow, size_t ahigh):
      index(aindex),
      size(asize),
      low(alow),
      high(ahigh){
    }

    size_t index;    // Index identifying which element of the input collection this is.
    size_t size;     // "Size" of this input element; this has different meanings
                     //   - if the collection is an std::vector this is the size of the input collection.
                     //   - if the collection is a cet::map_vector this is the difference between the
                     //     first and last keys in the input collection.

                     // Range of indices/keys in the output collection the correspond
                     // to the elements of this input collection:
    size_t low;      //   low end of the range
    size_t high;     //   one more than the high end of the range.
  };

  // When looping through the output collection, this class is used to help
  // keep track of where we are among the input collections.
  //
  //****************************Stepper****************************
  //
  template<class T>
  class Stepper {
  public:

    // Two different c'tors for different collection types.
    // They different in the call to .size() or .delta().

    Stepper( std::vector<size_t > const& offsets,
             std::vector<T> const&       out
               ):
      next_(0),
      info_(){

      completeConstruction ( offsets, out.size() );
    }

    Stepper( std::vector<size_t > const& offsets,
             cet::map_vector<T> const&   out
               ):
      next_(0),
      info_(){

      completeConstruction ( offsets, out.delta() );
    }

    // Return the information about the next input collection with
    // non-zero contents.
    
    StepInfo const& next() {

      for ( size_t i=next_; i!=info_.size(); ++i){
        StepInfo const& stepInfo = info_[i];
        if ( stepInfo.size > 0 ){
          next_ = i+1;
          return info_.at(i);
        }
      }

      // The user of this class should ensure that we never drop
      // through the loop.
      throw cet::exception("RANGE")
        << "Stepper::next : error navigating mixed collection to find Ptrs.\n"
        << __FILE__ << ":" << __LINE__ << "\n";
    }

    StepInfo const& info( size_t i) const{
        return info_.at(i);
    }

  private:

    size_t next_;
    std::vector<StepInfo> info_;

    void completeConstruction( std::vector<size_t > const& offsets, 
                               size_t lastHighWater ){
      info_.reserve(offsets.size());

      for ( size_t i=0; i!=offsets.size()-1; ++i){
        int s = offsets.at(i+1)-offsets.at(i);
        info_.push_back( StepInfo(i,s,offsets.at(i),offsets.at(i+1)));
      }
      int s = lastHighWater-offsets.back();
      info_.push_back( StepInfo(offsets.size()-1, s, 
                                offsets.back(), lastHighWater ));
    }

  }; 
  //
  //**************** End class Stepper****************************
  //

  // Sum of the sizes of all input collections.
  // This is a candidate to be moved to a more general library.
  template <class T>
  size_t totalSize( std::vector< T const*> const& in){
    size_t sum(0);
    for ( typename std::vector<T const*>::const_iterator 
            i=in.begin(), e=in.end();
          i !=e ; ++i ){
      sum += (*i)->size();
    }
    return sum;
  }

  // Fill output argument with size of each collection from the input argument.
  template <class T>
  void getSizes( std::vector< T const*> const& in, std::vector<size_t>& out){
    out.reserve(in.size());
    for ( typename std::vector<T const*>::const_iterator 
            i=in.begin(), e=in.end();
          i !=e ; ++i ){
      out.push_back((*i)->size());
    }
  }

  // Variant of getSizes for use when T is a cet::map_vector; call the delta()
  // method instead of the size() method.
  template <class T>
  void getDeltas( std::vector< T const*> const& in, std::vector<size_t>& out){
    out.reserve(in.size());
    for ( typename std::vector<T const*>::const_iterator 
            i=in.begin(), e=in.end();
          i !=e ; ++i ){
      out.push_back((*i)->delta());
    }
  }

} // end anonymous namespace

// Register mix operations and call produces<> for newly created data products
//
//*********************MixGenieEventsDetail::MixGenieEventsDetail****************
//
sim::MixGenieEventsDetail::MixGenieEventsDetail(fhicl::ParameterSet const &pSet,
					    art::MixHelper &helper)
  :
  // Run-time configurable parameters
  mean_(pSet.get<double>("meanPoisson")),
  genModuleLabel_(pSet.get<string>("genModuleLabel")),
  g4ModuleLabel_ (pSet.get<string>("g4ModuleLabel")),
  secondCollectionIsCosmic_ (pSet.get<bool>("secondCollectionIsCosmic")), 
  doPointTrajectories_(pSet.get<bool>("doPointTrajectories",true)),
  poisson_(0),
  n0_(pSet.get<unsigned int>("fixed")),
  mode_(pSet.get<string>("mode")),

  // Non-run-time configurable
  evtCount_(-1),
  stepCollectionCount_(-1),
  hNEvents_(0),
  actual_(0),
  genOffsets_(),
  simOffsets_()
  {

    n0_ = std::abs(n0_);
    mean_ = std::abs(mean_);

    // Declare new products produced directly by this class.
    //helper.produces<sim::MixingSummary>();

    // Register MixOp operations; the callbacks are called in the order
    // they were registered.

    helper.declareMixOp( art::InputTag(genModuleLabel_,""),
			 &MixGenieEventsDetail::mixMCTruth, *this );

  if(!secondCollectionIsCosmic_){
    helper.declareMixOp( art::InputTag(genModuleLabel_,""),
			 &MixGenieEventsDetail::mixMCFlux, *this );
  }


#ifdef LARSOFT
    helper.declareMixOp( art::InputTag(genModuleLabel_,""),
			 &MixGenieEventsDetail::mixGTruth, *this );
#endif
#ifdef NOVA
  if(!secondCollectionIsCosmic_){
    helper.declareMixOp( art::InputTag(genModuleLabel_,""),
			 &MixGenieEventsDetail::mixGTruth, *this );
  }
  helper.declareMixOp( art::InputTag(g4ModuleLabel_,""),
		       &MixGenieEventsDetail::mixParticle, *this );

  helper.declareMixOp( art::InputTag(g4ModuleLabel_,""),
		       &MixGenieEventsDetail::mixFLSHitList, *this );
#endif

  if ( mode_=="usePoisson" ) {
    art::RandomNumberGenerator::base_engine_t& engine = 
      art::ServiceHandle<art::RandomNumberGenerator>()->getEngine();
    int dummy(0);
    engine.setSeed( evgb::GetRandomNumberSeed(), dummy );
    //deprecated//poisson_ = auto_ptr<CLHEP::RandPoissonQ>( new CLHEP::RandPoissonQ(engine, mean_) );
    poisson_ = new CLHEP::RandPoissonQ(engine, mean_);
  }

  else if ( mode_=="usePoissonMinus1"          ) {
    art::RandomNumberGenerator::base_engine_t& engine = 
      art::ServiceHandle<art::RandomNumberGenerator>()->getEngine();
    int dummy(0);
    engine.setSeed( evgb::GetRandomNumberSeed(), dummy );
    double meanm1 = mean_ - 1;
    assert(meanm1 > 0);
    //deprecated//poisson_ = auto_ptr<CLHEP::RandPoissonQ>( new CLHEP::RandPoissonQ(engine, meanm1) );
    poisson_ = new CLHEP::RandPoissonQ(engine, meanm1);
  } 
  else if (mode_=="useFixed"){
    //  nothing need be done here
  }
  else std::cout << " Unknown mode " << std::endl;

  art::ServiceHandle<art::TFileService> tfs;
  int nbins;
  double xlow, xhigh;
  if(mode_=="usePoisson" ){
    PoissonBins(mean_,4.,nbins,xlow,xhigh);
  }
  else if (mode_=="usePoissonMinus1" ){
    PoissonBins(mean_- 1,4.,nbins,xlow,xhigh);
  }
  else if(mode_=="useFixed"){
    nbins=3;
    xlow =n0_- 1;
    xhigh = n0_ + 1;
  }

  hNEvents_ = tfs->make<TH1F>( "hNEvents", "Number of Mixed in Events",
                               nbins,xlow,xhigh);
  
  } // end sim::MixGenieEventsDetail::MixGenieEventsDetail

//
//*********************MixGenieEventsDetail Methods****************
//

// Initialize state for each event,
void  sim::MixGenieEventsDetail::startEvent(art::Event const &e) {
  stepCollectionCount_ = -1;
}

size_t sim::MixGenieEventsDetail::nSecondaries() {
  actual_ = ( mode_!="useFixed"  ) ? poisson_->fire(): n0_;
  hNEvents_->Fill(actual_);
  return actual_;
}

void sim::MixGenieEventsDetail::processEventIDs(art::EventIDSequence const &seq) {
}

void sim::MixGenieEventsDetail::finalizeEvent(art::Event &e) {
}

bool sim::MixGenieEventsDetail::mixMCTruth( std::vector< MCTruthVector const *> const& in,
					  MCTruthVector&                             out,
					  art::PtrRemapper const & ){

  // There are no Ptr's to update; just need to flatten.
  art::flattenCollections(in, out, genOffsets_ );
  return true;
}

bool sim::MixGenieEventsDetail::mixMCFlux( std::vector< MCFluxVector const *> const& in,
					 MCFluxVector&                              out,
					 art::PtrRemapper const & ){

  // There are no Ptr's to update; just need to flatten.
  art::flattenCollections(in, out, genOffsets_ );
  return true;
}

#if defined(NOVA) || defined(LARSOFT)
bool sim::MixGenieEventsDetail::mixGTruth( std::vector< GTruthVector const *> const& in,
					 GTruthVector&                             out,
					 art::PtrRemapper const & ){

  // There are no Ptr's to update; just need to flatten.
  art::flattenCollections(in, out, genOffsets_ );
  return true;
}
#endif

#ifdef NOVA
bool sim::MixGenieEventsDetail::mixParticle( std::vector< ParticleVector const *> const& in,
					   ParticleVector&                             out,
					   art::PtrRemapper const & ){


  // There are no Ptr's to update; just need to flatten.
  art::flattenCollections(in, out, genOffsets_ );
  return true;
}

bool sim::MixGenieEventsDetail::mixFLSHitList( std::vector< FLSHitListVector const *> const& in,
					     FLSHitListVector&                             out,
					     art::PtrRemapper const & ){

  // There are no Ptr's to update; just need to flatten.
  art::flattenCollections(in, out, genOffsets_ );
  return true;
}

#endif


DEFINE_ART_MODULE(sim::MixGenieEvents)
