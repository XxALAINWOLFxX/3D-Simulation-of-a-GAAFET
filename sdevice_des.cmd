/*
* Copyright (c) 2024, Shiv Nadar University, Delhi NCR, India. All Rights
* Reserved. Permission to use, copy, modify and distribute this software for
* educational, research, and not-for-profit purposes, without fee and without a
* signed license agreement, is hereby granted, provided that this paragraph and
* the following two paragraphs appear in all copies, modifications, and
* distributions.
*
* IN NO EVENT SHALL SHIV NADAR UNIVERSITY BE LIABLE TO ANY PARTY FOR DIRECT,
* INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST
* PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE.
*
* SHIV NADAR UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT
* NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
* PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS PROVIDED "AS IS". SHIV
* NADAR UNIVERSITY HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
* ENHANCEMENTS, OR MODIFICATIONS.
*/
 
/*
Revision History:
Date: 23/12/2024         By Swetabh Singh                    Change Notes: Added the copyright
------------  ---------------------- ------------------------------------------

File {
*Input Files

  Grid      = "n@node@_nGAAfinal_presim_fps.tdr"
  Parameter = "models.par"

*Output Files

  Plot      = "n@node@_tdr_nNS"
  Current   = "n@node@_nNS_transchar_tuneel50"
  Output    = "n@node@_log"
}


Electrode
{
* defines which contacts have to be treated as electrodes; initial bias
* & boundary conditions
{ name="source" Voltage=0.0 }
{ name="drain" Voltage=0.0 }
{ name="gate" Voltage=0.0 }
{ name="bulk" Voltage=0.0 }
}

Physics{

Mobility( DopingDep
          Enormal( RPS)

              HighFieldSaturation )
EffectiveIntrinsicDensity( BandGapNarrowing( OldSlotBoom ) NoFermi )
Recombination ( SRH(DopingDep) Auger Band2Band ( Model = Hurkx ) )
}
Physics (Material="Silicon")
{

        Aniso(eQuantumPotential(Direction(SimulationSystem)=(0,0,1)))

}
Physics (MaterialInterface = "Silicon/Oxide"){ GateCurrent( DirectTunneling )

} 

Plot{



*--Density and Currents, etc
   eDensity hDensity
   ConductionCurrentDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   eMobility/Element hMobility/Element

   eVelocity hVelocity
   eQuasiFermi hQuasiFermi
   ElectrostaticPotential

*--Fields and charges
   ElectricField/Vector Potential SpaceCharge

*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
   SRH Band2Band Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
   BandGap

   MetalWorkFunction
   BandGapNarrowing EffectiveBandGap
   Affinity ElectronAffinity
   ConductionBandEnergy ValenceBandEnergy
   eQuantumPotential hQuantumPotential

#--Tunneling
eSchenkTunnel hSchenkTunnel
}
Math
{

coordinateSystem { UCS }
-CheckUndefinedModels
GeometricDistances
* use previous two solutions (if any) to extrapolate next Extrapolate

* use full derivatives in Newton method
Derivatives
* control on relative and absolute errors
-RelErrControl
* relative error= 10^(-Digits)
Digits=5
* absolute error
Error(electron)=1e8
Error(hole)=1e8
* numerical parameter for space-charge regions
eDrForceRefDens=1e10
hDrForceRefDens=1e10
* maximum number of iteration at each step
Iterations=10
* solver of the linear system
Method=Pardiso
* display simulation time in 'human' units
Wallclock
* display max.error information
CNormPrint
* to avoid convergence problem when simulating defect-assisted tunneling NoSRHperPotential
StressMobilityDependence=TensorFactor
CheckRhsAfterUpdate
RHSmin=1e-12
Number_of_Threads = 4
}
Solve {

   *- Build-up of initial solution:
   Coupled { Poisson }
   Coupled (Iterations=100 LineSearchDamping=1e-4) { Poisson eQuantumPotential }
   Coupled { Poisson Electron eQuantumPotential }
   Coupled { Poisson Electron Hole eQuantumPotential }

    Save ( FilePrefix= "n@node@_init" )

    NewCurrentPrefix = "n@node@_IdVd1"
#-- Ramp drain to VdSat

  Quasistationary(
    InitialStep= 0.001 MinStep= 1e-7 MaxStep= 0.025
    Goal { Name= "drain" Voltage= 0.7 } )

   { Coupled { Poisson Electron Hole eQuantumPotential }
*I-V calculated at regular intervals

       CurrentPlot(Time=(Range=(0 1) Intervals=100))
    }

NewCurrentPrefix = "n@node@_IdVg1" #-- Vg sweep for Vd=VdSat

  Quasistationary(

InitialStep= 0.001 MinStep= 1e-7 MaxStep= 0.025
    Goal { Name= "gate" Voltage= 0.7 } )
    { Coupled { Poisson Electron Hole eQuantumPotential }

*I-V calculated at regular intervals
       CurrentPlot(Time=(Range=(0 1) Intervals=100))

}

}
