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
Date          By                     Change Notes
------------  ---------------------- ------------------------------------------

math coord.ucs
math numThreads=4
AdvancedCalibration 2017.09
pdbSet InfoDefault 1
pdbSet Mechanics StressRelaxFactor 1
pdbSet Math diffuse 3D ILS.hpc.mode 4
pdbSet Mechanics EtchDepoRelax 0
mgoals resolution= 1.0/3.0 accuracy=1e-6
pdbSet Grid SnMesh max.box.angle.3d 175
grid set.min.normal.size=0.005/1.0 \
  set.normal.growth.ratio.3d=2.0 \
  set.min.edge= 1e-7 set.max.points= 1000000 \
  set.max.neighbor.ratio= 1e6



set STI    0.015;
set H_STI  0.02;
set Tns    0.005;
set Spacing 0.01;
set H    [expr 4*$Spacing + 3*$Tns + $H_STI];
set Hfin [expr ($H - $STI)];
set Lg 0.012;
set HalfLg  [expr $Lg*0.5];
set Tox 0.0025;
set LSpacer 0.006;
set Lsd 0.012;
set CPP  [expr $Lg + 2*$LSpacer + 2*$Lsd];
set Wns 0.03
set FP [expr 2*$STI + $Wns];
set Tiox  0.001;

set Nsub  1.0e5;
set Nsd   1.0e13;
set Next  2e10;
set Nstop 3.0e11;

line x location= -70.0<nm> spacing=10.0<nm> tag= SiTop 
line x location= 20.0<nm> spacing= 10.0<nm>
line x location= 30.0<nm> spacing= 15.0<nm> tag= SiBottom

line y location= 0.0 spacing= 10.0<nm> tag= Left 
line y location= $FP spacing= 10.0<nm> tag= Right

line z location= 0.0 spacing= 15.0<nm> tag= Back 
line z location= $CPP spacing= 15.0<nm> tag= Front

#substrate

region Silicon xlo= SiTop xhi= SiBottom ylo= Left yhi= Right zlo= Back zhi= Front substrate

init concentration=$Nsub<cm-3> field=Boron wafer.orient= {0 0 1} flat.orient= {1 1 0} !DelayFullD

refinebox name= nw min= {-0.12 0 0.0} max= {0 0.38 0.45} xrefine= 5<nm> yrefine= 10<nm> zrefine=15<nm>

grid remesh

#-Epi layer with known doping concentration (well)

deposit material= {Silicon} type=isotropic time=1 rate= {$H}

deposit material= {SiliconGermanium} type=isotropic time=1 rate= {$Spacing}

deposit material= {Silicon} type=isotropic time=1 rate= {$Tns}

deposit material= {SiliconGermanium} type=isotropic time=1 rate= {$Spacing}



deposit material= {Silicon} type=isotropic time=1 rate= {$Tns}

deposit material= {SiliconGermanium} type=isotropic time=1 rate= {$Spacing}

deposit material= {Silicon} type=isotropic time=1 rate= {$Tns}

deposit material= {SiliconGermanium} type=isotropic time=1 rate= {$Spacing}

#---Sidewall Image Transfer (SIT)

#dry oxidation

diffuse temperature= 900<C> time= 4.0<min> O2

struct tdr= n@node@_pGAA3 ;#deposit SiO2, hardmask, mandrel

deposit material= {Nitride} type= isotropic time= 1<min> rate= {0.0165} 
deposit material= {AmorphousSilicon} type= isotropic time= 1<min> rate= {0.1}
struct tdr= n@node@_pGAA3b 



mask name= fin left= 0<nm> right= [expr $STI + $Wns] back= -1 front= 0.17<um> negative

etch material= {AmorphousSilicon} type= anisotropic time= 1<min> rate= {0.1} mask= fin

deposit material= {Oxide} type= isotropic time= 1 rate= {0.035}

etch material= {Oxide} type= anisotropic time= 1 rate= {0.045} isotropic.overetch= 0.1
struct tdr= n@node@_pGAA3c ;

etch material= {AmorphousSilicon} type= anisotropic time=1<min> rate= {0.3} 
etch material= {Nitride} type=anisotropic time= 1<min> rate= {0.02}

struct tdr= n@node@_pGAA3d_etchAM;

#etch oxide on top of superlattice

etch material= {Oxide} type= anisotropic time=1 rate= {0.035} 
etch material= {Silicon SiliconGermanium} type=anisotropic time=1<min> rate= {$H}
struct tdr= n@node@_pGAA3d_finForm;


#TEOS STI $H+0.0165

mater add name=TEOS new.like=oxide

deposit material= {TEOS} type= isotropic time= 1<min> rate= {$H}

etch material= {TEOS} type=cmp etchstop= {Nitride} etchstop.overetch=0.0001
struct tdr=n@node@_pGAA3e_TEOS ;


#-etch spacers 4 fin

etch material= {Oxide} type= anisotropic time=1<min> rate= {0.07} 

etch material= {TEOS} type=isotropic time=1 rate= {($H-$H_STI+0.02-0.001+0.00009)}


etch material= {Nitride} type=anisotropic time=1 rate= {0.02}

etch material= {Oxide} type= anisotropic time=1<min> rate= {0.035}
struct tdr= n@node@_pGAA3f_etchMasks ;



#Punch through stop layer

refinebox name= etchstop min= {-0.13 0 0.0} max= {-0.04 0.040 0.045} xrefine= 4<nm> yrefine= 10<nm> zrefine= 10<nm>

grid remesh

implant Boron dose= $Nstop<cm-2> energy=8<keV> tilt=0 rotation=90 
implant Boron dose= $Nstop<cm-2> energy=8<keV> tilt=0 rotation=270

SetPlxList {PTotal}
WritePlx n@node@_PMOS_etchstoplayer.plx y=0.03 z=0.0 Silicon

implant Boron dose= $Nstop<cm-2> energy=9<keV> tilt=0 rotation=90 
implant Boron dose= $Nstop<cm-2> energy=9<keV> tilt=0 rotation=270

SetPlxList {PTotal}

WritePlx n@node@_PMOS_etchstoplayer.plx y=0.03 z=0.0 Silicon

implant Boron dose= $Nstop<cm-2> energy=10<keV> tilt=0 rotation=90
implant Boron dose= $Nstop<cm-2> energy=10<keV> tilt=0 rotation=270

SetPlxList {PTotal}

WritePlx n@node@_PMOS_etchstoplayer.plx y=0.03 z=0.0 Silicon

diffuse temperature=300<C> time=0.0001<s>

struct tdr= n@node@_pGAA4_PTSLdiff;

#Dummy gate

deposit material= {Oxide} type= isotropic time=1 rate= {$Tiox}

deposit material= {Polysilicon} type= fill coord= -0.25 
struct tdr= n@node@_nGAA4_dummygatepre

mask name= gate back= ($Lsd+$LSpacer)<um> front= ($CPP-$Lsd-$LSpacer)<um>                   
etch material= {Polysilicon} type= anisotropic time=1 rate= {0.2} mask= gate

struct tdr= n@node@_pGAA4_dummygate;

#S/D extension LDD


mask name= gate_neg back= ($Lsd)<um> front= ($CPP-$Lsd)<um> negative
photo thickness= 5<um> mask= gate_neg

implant Phosphorus dose= $Next<cm-2> energy=1.8<keV> tilt=-70<degree> rotation=-90<degree>

implant Phosphorus dose= $Next<cm-2> energy=1.8<keV> tilt=-70<degree> rotation=-270<degree>

implant Phosphorus dose= $Next<cm-2> energy=1.8<keV> tilt=-70<degree> rotation=-90<degree>

implant Phosphorus dose= $Next<cm-2> energy=1.8<keV> tilt=-70<degree> rotation=-270<degree>

SetPlxList {BTotal BoronImplant}

WritePlx n@node@_NMOS_sdext.plx y=0.03 z=0.0 Silicon

SetPlxList {PTotal BTotal}

WritePlx n@node@_PMOS_sdext2X.plx y=0.03 z=0.0 Silicon

SetPlxList {PTotal BTotal}

WritePlx nOnode®_PMOS_sdext2Y.plx y=-0.12 z=0.0 Silicon

strip Photoresist 

struct tdr= n@node@_pGAA4_LDD;

strip Photoresist

#diffuse LDD RTA

diffuse temperature=300<C> time=0.00001<s>

struct tdr= n@node@_pGAA4_LDDdiff;

#spacer fabrication

mask name= inner_neg back= ($Lsd+$LSpacer)<um> front=($CPP-$Lsd+$LSpacer)<um> negative

etch material= {Oxide} type=anisotropic time=1 rate=1.0

etch material= {SiliconGermanium} type= anisotropic time=1 rate= {0.18} mask= gate

struct tdr= n@node@_pGAA6_anisoetch ;

deposit material= {Oxide} type= isotropic time=1<min> rate= {$Tiox} selective.materials= {PolySilicon}

etch material= {Oxide} type=cmp etchstop= {PolySilicon} etchstop.overetch=0.001

struct tdr= n@node@_pGAA7_sidewall ;

mask name= spacer_neg back= ($Lsd)<um> front= ($CPP-$Lsd)<um> negative


deposit material= {Nitride} type= anisotropic time=1<min> rate= {0.2} mask=spacer_neg

etch material= {Nitride} type=cmp etchstop= {PolySilicon} etchstop.overetch=0.001

struct tdr= n@node@_pGAA8_spacerfab ;

# SiOCN protection

mask name= spacer_neg back= ($Lsd)<um> front= ($CPP-$Lsd)<um> negative

mater add name=SiCN new.like= Nitride 
deposit material= {SiCN} type=anisotropic time=1 rate= {0.05} mask= spacer_neg

struct tdr= n@node@_pGAA9_Si0CNprot ;

#Etch Silicon for SD epi

etch material= {Silicon} type= isotropic rate= {0.01} time= 15<s> 
struct tdr= n@node@_pGAA9_SietchSD ;

#---EPI OF SD


#To activate stress in SiC pocket for nFinFET# 
pdbSetDoubleArray Silicon Germanium Conc.Strain {0 0 1 -0.0425} 
pdbSetDouble Carbon Mechanics TopRelaxedNodeCoord 0.05e-4

# Diamond-shaped Si/SiGe Pocket using Lattice Kinetic Monte Carlo (LKMC)

pdbSet Grid KMC UseLines 1 
pdbSet KMC Epitaxy true
pdbSetBoolean LKMC PeriodicBC false
pdbSet LKMC Epitaxy.Model Coordinations.Planes

set EpiDoping_init "Carbon= 1.5e21" 
set EpiDoping_final "Carbon= 1.5e21"

temp_ramp name= epi temperature= 500<C> t.final= 550<C> time= 2<min> Epi epi.doping= $EpiDoping_init epi.doping.final= #$EpiDoping_final epi.model= 1 epi.thickness= 0.055<um>

diffuse temp_ramp= epi lkmc

#false to model doping non atomistically 
pdbSet KMC Epitaxy false

struct tdr= n@node@_pGAA10_SiGe_SD_epi;

#gate refine silicon

refinebox name= gate min= {-0.0125 0.0 0.012} max= {-0.18 0.040 0.0} xrefine=2.0<nm> yrefine= 2.0<nm> zrefine= 2.0<nm>


#source refine silicon

refinebox name= source min= {-0.010 0.0 0.036} max= {-0.18 0.040 0.45} xrefine= 5.0<nm> yrefine= 7.0<nm> zrefine= 10.0<nm>

#drain refine silicon

refinebox name= drain min= {-0.010 0.0 0.0} max= {-0.2 0.040 0.0085} xrefine= 5.0<nm> yrefine= 7.0<nm> zrefine= 10.0<nm>

struct tdr= n@node@_nGAA10_SD_refine ;

# S/D Implantation

#original 1

implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=90 
implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=270

implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=90 
implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=270

implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=90 
implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=270

implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=90 
implant Phosphorus dose= $Nsd<cm-2> energy=1<keV> tilt=-0 rotation=270

SetPlxList {Phosporus Boron_Implant}

WritePlx n@node@_NMOS_sdimp.plx y=0.03 z=0.0 Silicon

#etch SiOCN

mater add name=SiCN new.like= Nitride

etch material= {SiCN} type=isotropic rate=1.0 time=1

diffuse temperature=500<C> time=0.1<s>

WritePlx n@node®_NMOS_sddiff.plx y=0.03 z=0.0 Silicon

struct tdr= n@node@_nGAA10_SDdoping ;

#-Silicidation

deposit material= {TiSilicide} type= isotropic rate= 0.02*$Hfin time=1.0 temperature= 500 selective.materials= {Silicon}

struct tdr= n@node@_nGAA10_Silicides ;

#PSG ILDO
mater add name= PSG
ambient name=Silane react add 
reaction name= PSGreaction mat.l= Phosphorus mat.r= Oxide mat.new= PSG new.like= Oxide ambient.name= {Silane} diffusing.species= {Silane}
deposit material= {PSG} type= isotropic time=1 rate= {0.2}
etch material= {PSG} type=cmp etchstop= {Nitride} etchstop.overetch=0.01

# Dummy gate etching

strip Polysilicon 
strip Oxide

#---SELECTIVE ETCHING OF SIGE

etch material= {SiliconGermanium} type=isotropic time=1 rate= {0.1}

struct tdr= n@node@_nGAA11_etchDummySiGe;

#----RMG

#buffer oxide

#no used etchstop.overetch=0.01

deposit material= {Oxide} type= isotropic time=1 rate= {$Tiox} 
etch material= {Oxide} type=cmp etchstop= {Silicon}
struct tdr= n@node@_nGAA12_newOxide;

#Hfo2

deposit material= {HfO2} type= isotropic time=1 rate= {$Tiox} selective.materials= {Oxide}

etch material= {HfO2} type=cmp etchstop= {Silicon}
struct tdr= n@node@_nGAA12_Hf02;

#refinebox name= MIG min= {-0.014 0.0 0.0} max= {-0.2 0.048 0.06} xrefine=2.0<nm> yrefine= 2.0<nm> zrefine= 2.0<nm>

mask name= gate_neg back= ($Lsd)<um> front= ($CPP-$Lsd)<um> negative

#TiN metal stack

deposit material= {TiN} type= isotropic time=1 rate= 0.0007 mask = gate_neg selective.materials= {HfO2}

etch material= {TiN} type=cmp etchstop = {PSG}

mater add name=TaN new.like= TiN

deposit material= {TaN} type= isotropic time=1 rate= 0.0007 mask = gate_neg selective.materials= {TiN}

etch material= {TaN} type=cmp etchstop = {PSG}

struct tdr= n@node@_nGAA12_TaN;

mater add name=TiAl new.like= Aluminium


deposit material= {TiAl} type=isotropic time=1 rate = 0.002 selective.materials= {TaN}

etch material= {TiAl} type=cmp coord = -0.197064 etchstop.overetch=2

deposit material= {TiAl} type=isotropic time=1 rate = 0.002 selective.materials= {TaN}

etch material= {TiAl} type=isotropic thickness = 0.00035

diffuse temp=250<C> time=1.0e-6<s> stress.relax

ambient clear

struct tdr= n@node@_nGAA12_TiAl;

# Tungsten contact

deposit material= {Tungsten} type=fill coord= -0.25

etch material= {Tungsten} type=cmp etchstop= {PSG} etchstop.overetch=0.01

struct tdr= n@node@_nGAA12_Tungsten;

#=--SAC

#deposit nitride

mater add name= PSG

etch material= {Tungsten} type=isotropic time=1 rate= {0.003}

deposit material= {Nitride} type=fill coord=-0.25

etch material= {Nitride} type=cmp etchstop= {PSG} etchstop.overetch=0.1

mask name=s left=20<nm> right=40<nm> back=2<nm> front=10<nm> negative 
mask name=d left=20<nm> right=40<nm> back=38<nm> front=46<nm> negative 
mask name=g left=20<nm> right=40<nm> back=20<nm> front=28<nm> negative

#SD tungsten

etch material= {PSG} type=anisotropic time=1 rate= {0.9} mask=s 
etch material= {PSG} type=anisotropic time=1 rate= {0.9} mask=d

#etch SAC nitride

etch material= {Nitride} type=anisotropic time=1 rate= {0.2} mask=g 
deposit material= {Tungsten} type=fill coord=-0.25

etch material= {Tungsten} type=cmp etchstop= {Nitride} etchstop.overetch=0.05

struct tdr= n@node@_nGAA13_SAC;

transform cut location= -0.05 down

# clear the process simulation mesh

refinebox clear

refinebox !keep.lines

line clear


# reset default settings for adaptive meshing

pdbSet Grid AdaptiveField Refine.Abs.Error 1e37 
pdbSet Grid AdaptiveField Refine.Rel.Error 1e10
pdbSet Grid AdaptiveField Refine.Target.Length 100.0

# Set high quality Delaunay meshes

pdbSet Grid sMesh 1

pdbSet Grid Adaptive 1

pdbSet Grid SnMesh DelaunayType boxmethod

pdbSet Grid SnMesh DelaunayTolerance 5.0e-2

pdbSet Grid SnMesh CoplanarityAngle 179

pdbSet Grid SnMesh MaxPoints 2000000

pdbSet Grid SnMesh max.box.angle.3d 179

#gate refine silicon

refinebox name= gatefinal min= {-0.25 0.0 0.12} max= {-0.12 0.06 0.036} xrefine=2.0<nm> yrefine= 2.0<nm> zrefine= 5.0<nm> materials= {Silicon}

#source refine silicon

refinebox name= sourcefinal min= {-0.25 0.0 0.036} max= {-0.12 0.06 0.48} xrefine= 5.0<nm> yrefine= 5.0<nm> zrefine=5.0<nm> materials= {Silicon}

#drain refine silicon

refinebox name= drainfinal min= {-0.25 0.0 0.0} max= {-0.12 0.060 0.0012} xrefine= 5.0<nm> yrefine= 5.0<nm> zrefine= 5.0<nm> materials= {Silicon}
 #channel refine silicon

refinebox name= channelfinal min= {-0.19 0.014 0.01} max= {-0.145 0.046 0.04} xrefine=1.5<nm> yrefine= 1.5<nm> zrefine= 1.5<nm> materials= {Silicon}

#silicide refines

refinebox name= Tisource min= {-0.25 0.0 0.0} max= {-0.12 0.04 0.45} xrefine= 1.5<nm> yrefine= 2.0<nm> zrefine= 3.0<nm> materials= {TiSilicide}

refinebox name= Tidrain min= {-0.25 0.0 0.0} max= {-0.12 0.04 0.0085} xrefine= 1.5<nm> yrefine= 2.0<nm> zrefine= 3.0<nm> materials= {TiSilicide}

grid remesh

struct tdr= n@node@_nGAA_remesh ;

contact bottom name= bulk Silicon

contact name= gate x= -0.248 y= 0.03 z= 0.024 Tungsten

contact name= source x= -0.248 y= 0.03 z= 0.042 Tungsten

contact name= drain x= -0.248 y= 0.03 z= 0.006 Tungsten

struct tdr= n@node@_nGAAfinal_presim !Gas

exit 
