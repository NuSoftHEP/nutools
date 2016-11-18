//
// Build a dictionary.
//
// $Id: classes.h,v 1.9 2012-10-29 16:42:11 brebel Exp $
// $Author: brebel $
// $Date: 2012-10-29 16:42:11 $
// 
// Original author Rob Kutschke, modified by klg
//
// Notes:
// 1) The system is not able to deal with
//    art::Wrapper<std::vector<std::string> >;
//    The problem is somewhere inside root's reflex mechanism
//    and Philippe Canal says that it is ( as of March 2010) a
//    known problem.  He also says that they do not have any
//    plans to fix it soon.  We can always work around it 
//    by putting the string inside another object.

#include "art/Persistency/Common/Wrapper.h"
#include "art/Persistency/Common/Assns.h" 

// nutools includes
#include "SimulationBase/MCTruth.h"
#include "SimulationBase/MCTrajectory.h"
#include "SimulationBase/MCParticle.h"
#include "SimulationBase/MCNeutrino.h"
#include "SimulationBase/MCFlux.h"
#include "SimulationBase/GTruth.h"
#include <TLorentzVector.h>

#include "dk2nu/tree/dk2nu.h"
#include "dk2nu/tree/NuChoice.h"

//
// Only include objects that we would like to be able to put into the event.
// Do not include the objects they contain internally.
//
template class std::pair< TLorentzVector, TLorentzVector>;
template class std::vector<simb::MCNeutrino>;
template class std::vector<simb::MCTrajectory>;
template class std::vector<simb::MCParticle>;
template class std::vector<simb::MCTruth>;
template class std::vector<simb::MCFlux>;
template class std::vector<simb::GTruth>;

template class std::pair< art::Ptr<simb::MCFlux>,     art::Ptr<simb::MCTruth>    >;
template class std::pair< art::Ptr<simb::MCTruth>,    art::Ptr<simb::MCFlux>     >;
template class std::pair< art::Ptr<simb::GTruth>,     art::Ptr<simb::MCTruth>    >;
template class std::pair< art::Ptr<simb::MCTruth>,    art::Ptr<simb::GTruth>     >;
template class std::pair< art::Ptr<simb::MCParticle>, art::Ptr<simb::MCTruth>    >;
template class std::pair< art::Ptr<simb::MCTruth>,    art::Ptr<simb::MCParticle> >;


template class art::Assns<simb::MCFlux,     simb::MCTruth,    void>;
template class art::Assns<simb::MCTruth,    simb::MCFlux,     void>;
template class art::Assns<simb::GTruth,     simb::MCTruth,    void>;
template class art::Assns<simb::MCTruth,    simb::GTruth,     void>;
template class art::Assns<simb::MCParticle, simb::MCTruth,    void>;
template class art::Assns<simb::MCTruth,    simb::MCParticle, void>;

template class art::Wrapper< std::vector<simb::MCNeutrino> >;
template class art::Wrapper< std::vector<simb::MCTrajectory> >;
template class art::Wrapper< std::vector<simb::MCParticle> >;
template class art::Wrapper< std::vector<simb::MCTruth> >;
template class art::Wrapper< std::vector<simb::MCFlux> >;
template class art::Wrapper< std::vector<simb::GTruth> >;

template class art::Wrapper< art::Assns<simb::MCParticle, simb::MCTruth,    void> >;
template class art::Wrapper< art::Assns<simb::MCTruth,    simb::MCParticle, void> >;
template class art::Wrapper< art::Assns<simb::MCFlux,     simb::MCTruth,    void> >;
template class art::Wrapper< art::Assns<simb::MCTruth,    simb::MCFlux,     void> >;
template class art::Wrapper< art::Assns<simb::GTruth,     simb::MCTruth,    void> >;
template class art::Wrapper< art::Assns<simb::MCTruth,    simb::GTruth,     void> >;

// mumbo jumbo for introducting bsim::Dk2Nu and friends
////////////////////////////////////////////////////////////////////////////////////

// try nothing special but the things we need to wrap bsim::Dk2Nu
template class std::vector<bsim::Dk2Nu>;
template class art::Ptr<bsim::Dk2Nu>;
template class art::Wrapper< std::vector<bsim::Dk2Nu> >;
// for associations
template class std::pair< art::Ptr<simb::MCTruth>,    art::Ptr<bsim::Dk2Nu>   >;
template class std::pair< art::Ptr<bsim::Dk2Nu>,      art::Ptr<simb::MCTruth> >;
template class art::Assns<simb::MCTruth,    bsim::Dk2Nu,      void>;
template class art::Assns<bsim::Dk2Nu,      simb::MCTruth,    void>;
template class art::Wrapper< art::Assns<simb::MCTruth, bsim::Dk2Nu,   void> >;
template class art::Wrapper< art::Assns<bsim::Dk2Nu,   simb::MCTruth, void> >;

// try nothing special but the things we need to wrap bsim::NuChoice
template class std::vector<bsim::NuChoice>;
template class art::Ptr<bsim::NuChoice>;
template class art::Wrapper< std::vector<bsim::NuChoice> >;
// for associations
template class std::pair< art::Ptr<simb::MCTruth>,  art::Ptr<bsim::NuChoice> >;
template class std::pair< art::Ptr<bsim::NuChoice>, art::Ptr<simb::MCTruth> >;
template class art::Assns<simb::MCTruth,    bsim::NuChoice,   void>;
template class art::Assns<bsim::NuChoice,   simb::MCTruth,    void>;
template class art::Wrapper< art::Assns<simb::MCTruth,  bsim::NuChoice, void> >;
template class art::Wrapper< art::Assns<bsim::NuChoice, simb::MCTruth,  void> >;

// end-of-additions
