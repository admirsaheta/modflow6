MODULE GWFLAKMODULE

!C------OLD USGS VERSION 7.1; JUNE 2006 GWFLAKMODULE;
!C------UPDATED FOR MF-2005, 1.9 RELEASE, FEBRUARY 6, 2012
  CHARACTER(LEN=64),PARAMETER ::Version_lak = &
      '$Id: gwf2lak7_NWT.f 2370 2012-04-05 17:35:48Z rniswon $'
  INTEGER,SAVE,POINTER   ::NLAKES,NLAKESAR,ILKCB,NSSITR,LAKUNIT
  INTEGER,SAVE,POINTER   ::MXLKND,LKNODE,ICMX,NCLS,LWRT,NDV,NTRB, &
                          IRDTAB
  logical, save, pointer :: NeedLakWaterMover => null()
  REAL,   SAVE,POINTER   ::THETA,SSCNCR,SURFDEPTH
!Cdep    Added SURFDEPTH  3/3/2009
!Crgn    Added budget variables for GSFLOW CSV file
  REAL,   SAVE,POINTER   ::TOTGWIN_LAK,TOTGWOT_LAK,TOTDELSTOR_LAK
  REAL,   SAVE,POINTER   ::TOTSTOR_LAK,TOTEVAP_LAK,TOTPPT_LAK
  REAL,   SAVE,POINTER   ::TOTRUNF_LAK,TOTWTHDRW_LAK,TOTSURFIN_LAK
  REAL,   SAVE,POINTER   ::TOTSURFOT_LAK
  INTEGER,SAVE, DIMENSION(:),  POINTER ::ICS, NCNCVR, LIMERR, &
                                        LAKTAB
  INTEGER,SAVE, DIMENSION(:,:),POINTER ::ILAKE,ITRB,IDIV,ISUB,IRK
  INTEGER,SAVE, DIMENSION(:,:,:),POINTER ::LKARR1
  REAL,   SAVE, DIMENSION(:),  POINTER ::STAGES
  DOUBLE PRECISION,SAVE,DIMENSION(:), POINTER ::STGNEW,STGOLD, &
                                       STGITER,VOLOLDD,STGOLD2
  REAL,   SAVE, DIMENSION(:),  POINTER ::VOL,FLOB,DSRFOT
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::PRCPLK,EVAPLK
  REAL,   SAVE, DIMENSION(:),  POINTER ::BEDLAK
  REAL,   SAVE, DIMENSION(:),  POINTER ::WTHDRW,RNF,CUMRNF
  REAL,   SAVE, DIMENSION(:),  POINTER ::CUMPPT,CUMEVP,CUMGWI
  REAL,   SAVE, DIMENSION(:),  POINTER ::CUMUZF
  REAL,   SAVE, DIMENSION(:),  POINTER ::CUMGWO,CUMSWI,CUMSWO
  REAL,   SAVE, DIMENSION(:),  POINTER ::CUMWDR,CUMFLX,CNDFCT
  REAL,   SAVE, DIMENSION(:),  POINTER ::VOLINIT
  REAL,   SAVE, DIMENSION(:),  POINTER ::BOTTMS,BGAREA,SSMN,SSMX
!Cdep    Added cumulative and time step error budget arrays
  REAL,   SAVE, DIMENSION(:),  POINTER ::CUMVOL,CMLAKERR,CUMLKOUT
  REAL,   SAVE, DIMENSION(:),  POINTER ::CUMLKIN,TSLAKERR,DELVOL
!crgn        REAL,   SAVE, DIMENSION(:),  POINTER ::EVAP,PRECIP,SEEP,SEEP3
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::EVAP,PRECIP
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::EVAP3,PRECIP3
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::FLWITER
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::FLWITER3
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::SEEP,SEEP3
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::SEEPUZ
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::WITHDRW
  DOUBLE PRECISION,   SAVE, DIMENSION(:),  POINTER ::SURFA
  REAL,   SAVE, DIMENSION(:),  POINTER ::SURFOT,SURFIN
  REAL,   SAVE, DIMENSION(:),  POINTER ::SUMCNN,SUMCHN
  REAL,   SAVE, DIMENSION(:,:),POINTER ::CLAKE,CRNF,SILLVT
  REAL,   SAVE, DIMENSION(:,:),POINTER ::CAUG,CPPT,CLAKINIT
  double precision,   SAVE, DIMENSION(:,:,:),POINTER ::BDLKN1
!Cdep  Added arrays for tracking lake budgets for dry lakes
  REAL,   SAVE, DIMENSION(:),  POINTER ::EVAPO,FLWIN
  REAL,   SAVE, DIMENSION(:),  POINTER ::GWRATELIM
!Cdep    Allocate arrays to add runoff from UZF Package
  REAL,   SAVE, DIMENSION(:),  POINTER ::OVRLNDRNF,CUMLNDRNF
!Cdep    Allocate arrays for lake depth, area,and volume relations
  DOUBLE PRECISION,   SAVE, DIMENSION(:,:),  POINTER ::DEPTHTABLE
  DOUBLE PRECISION,   SAVE, DIMENSION(:,:),  POINTER ::AREATABLE
  DOUBLE PRECISION,   SAVE, DIMENSION(:,:),  POINTER ::VOLUMETABLE
!Cdep    Allocate space for three dummy arrays used in GAGE Package
!C         when Solute Transport is active
  REAL,   SAVE, DIMENSION(:,:),POINTER ::XLAKES,XLAKINIT,XLKOLD
!Crsr    Allocate arrays in BD subroutine
  INTEGER,SAVE, DIMENSION(:),  POINTER ::LDRY,NCNT,NCNST,KSUB
  INTEGER,SAVE, DIMENSION(:),  POINTER ::MSUB1
  INTEGER,SAVE, DIMENSION(:,:),POINTER ::MSUB
  REAL,   SAVE, DIMENSION(:),  POINTER ::FLXINL,VOLOLD,GWIN,GWOUT
  REAL,   SAVE, DIMENSION(:),  POINTER ::DELH,TDELH,SVT,STGADJ
  REAL,   SAVE, DIMENSION(:,:),POINTER ::LAKSEEP

  TYPE GWFLAKTYPE
    INTEGER,      POINTER   ::NLAKES,NLAKESAR,ILKCB,NSSITR,LAKUNIT
    INTEGER,      POINTER   ::MXLKND,LKNODE,ICMX,NCLS,LWRT,NDV,NTRB, &
                             IRDTAB
    logical, pointer        :: NeedLakWaterMover
!Cdep    Added SURFDEPTH 3/3/2009
    REAL,         POINTER   ::THETA,SSCNCR,SURFDEPTH
!Crgn    Added budget variables for GSFLOW CSV file
    REAL,         POINTER   ::TOTGWIN_LAK,TOTGWOT_LAK,TOTDELSTOR_LAK
    REAL,         POINTER   ::TOTSTOR_LAK,TOTEVAP_LAK,TOTPPT_LAK
    REAL,         POINTER   ::TOTRUNF_LAK,TOTWTHDRW_LAK
    REAL,         POINTER   ::TOTSURFOT_LAK,TOTSURFIN_LAK
    INTEGER,      DIMENSION(:),  POINTER ::ICS, NCNCVR, LIMERR, &
                                          LAKTAB
    INTEGER,      DIMENSION(:,:),POINTER ::ILAKE,ITRB,IDIV,ISUB,IRK
    INTEGER,      DIMENSION(:,:,:),POINTER ::LKARR1
    REAL,         DIMENSION(:),  POINTER ::STAGES
    DOUBLE PRECISION,DIMENSION(:),POINTER ::STGNEW,STGOLD,STGITER, &
                                         STGOLD2
    DOUBLE PRECISION,DIMENSION(:),POINTER :: VOLOLDD
    REAL,         DIMENSION(:),  POINTER ::VOL,FLOB, DSRFOT
    DOUBLE PRECISION,DIMENSION(:),  POINTER ::PRCPLK,EVAPLK
    REAL,         DIMENSION(:),  POINTER ::BEDLAK
    REAL,         DIMENSION(:),  POINTER ::WTHDRW,RNF,CUMRNF
    REAL,         DIMENSION(:),  POINTER ::CUMPPT,CUMEVP,CUMGWI
    REAL,         DIMENSION(:),  POINTER ::CUMUZF
    REAL,         DIMENSION(:),  POINTER ::CUMGWO,CUMSWI,CUMSWO
    REAL,         DIMENSION(:),  POINTER ::CUMWDR,CUMFLX,CNDFCT
    REAL,         DIMENSION(:),  POINTER ::VOLINIT
    REAL,         DIMENSION(:),  POINTER ::BOTTMS,BGAREA,SSMN,SSMX
!Cdep    Added cumulative and time step error budget arrays
    REAL,         DIMENSION(:),  POINTER ::CUMVOL,CMLAKERR,CUMLKOUT
    REAL,         DIMENSION(:),  POINTER ::TSLAKERR,DELVOL,CUMLKIN
!Crgn        REAL,         DIMENSION(:),  POINTER ::EVAP,PRECIP,SEEP,SEEP3
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: EVAP,PRECIP
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: EVAP3,PRECIP3
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: FLWITER
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: FLWITER3
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: SEEP,SEEP3
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: SEEPUZ
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: WITHDRW
    DOUBLE PRECISION,DIMENSION(:),  POINTER :: SURFA
    REAL,         DIMENSION(:),  POINTER ::SURFIN,SURFOT
    REAL,         DIMENSION(:),  POINTER ::SUMCNN,SUMCHN
    REAL,         DIMENSION(:,:),POINTER ::CLAKE,CRNF,SILLVT
    REAL,         DIMENSION(:,:),POINTER ::CAUG,CPPT,CLAKINIT
    double precision,         DIMENSION(:,:,:),POINTER ::BDLKN1
!Cdep  Added arrays for tracking lake budgets for dry lakes
    REAL,         DIMENSION(:),  POINTER ::EVAPO,FLWIN
    REAL,         DIMENSION(:),  POINTER ::GWRATELIM
!Cdep    Allocate arrays to add runoff from UZF Package
    REAL,         DIMENSION(:),  POINTER ::OVRLNDRNF,CUMLNDRNF
!Cdep    Allocate arrays for lake depth, area, and volume relations
    DOUBLE PRECISION,         DIMENSION(:,:),POINTER ::DEPTHTABLE
    DOUBLE PRECISION,         DIMENSION(:,:),POINTER ::AREATABLE
    DOUBLE PRECISION,         DIMENSION(:,:),POINTER ::VOLUMETABLE
!Cdep    Allocate space for three dummy arrays used in GAGE Package
!C         when Solute Transport is active
    REAL,         DIMENSION(:,:),POINTER ::XLAKES,XLAKINIT,XLKOLD
!Crsr    Allocate arrays in BD subroutine
    INTEGER,      DIMENSION(:),  POINTER ::LDRY,NCNT,NCNST,KSUB
    INTEGER,      DIMENSION(:),  POINTER ::MSUB1
    INTEGER,      DIMENSION(:,:),POINTER ::MSUB
    REAL,         DIMENSION(:),  POINTER ::FLXINL,VOLOLD,GWIN,GWOUT
    REAL,         DIMENSION(:),  POINTER ::DELH,TDELH,SVT,STGADJ
    REAL,         DIMENSION(:,:),POINTER ::LAKSEEP
  END TYPE

  TYPE(GWFLAKTYPE), SAVE:: GWFLAKDAT(10)

contains

  SUBROUTINE GWF2LAK7DA(IUNITLAK, IGRID)
!Cdep  End of FUNCTIONS used for Newton method in
!Cdep     FORMULATE SUBROUTINE (LAK7FM).
!C  Deallocate LAK data
!C     ------------------------------------------------------------------
!C     ARGUMENTS
!C     ------------------------------------------------------------------
    INTEGER, INTENT(IN) :: IUNITLAK, IGRID
!C
    DEALLOCATE (GWFLAKDAT(IGRID)%NLAKES)
    DEALLOCATE (GWFLAKDAT(IGRID)%NLAKESAR)
    DEALLOCATE (GWFLAKDAT(IGRID)%THETA)
    DEALLOCATE (GWFLAKDAT(IGRID)%STGNEW)
    DEALLOCATE (GWFLAKDAT(IGRID)%STGOLD)
    DEALLOCATE (GWFLAKDAT(IGRID)%STGOLD2)
    DEALLOCATE (GWFLAKDAT(IGRID)%STGITER)
    DEALLOCATE (GWFLAKDAT(IGRID)%VOL)
    DEALLOCATE (GWFLAKDAT(IGRID)%LAKUNIT)
    IF ( IUNITLAK.LT.1 ) RETURN

    DEALLOCATE (GWFLAKDAT(IGRID)%ILKCB)
    DEALLOCATE (GWFLAKDAT(IGRID)%LAKTAB)
    DEALLOCATE (GWFLAKDAT(IGRID)%IRDTAB)
    deallocate (GWFLAKDAT(IGRID)%NeedLakWaterMover)
    DEALLOCATE (GWFLAKDAT(IGRID)%NSSITR)
!Cdep  deallocate SURFDEPTH 3/3/2009
    DEALLOCATE (GWFLAKDAT(IGRID)%SURFDEPTH)
    DEALLOCATE (GWFLAKDAT(IGRID)%MXLKND)
    DEALLOCATE (GWFLAKDAT(IGRID)%LKNODE)
    DEALLOCATE (GWFLAKDAT(IGRID)%ICMX)
    DEALLOCATE (GWFLAKDAT(IGRID)%NCLS)
    DEALLOCATE (GWFLAKDAT(IGRID)%LWRT)
    DEALLOCATE (GWFLAKDAT(IGRID)%NDV)
    DEALLOCATE (GWFLAKDAT(IGRID)%NTRB)
    DEALLOCATE (GWFLAKDAT(IGRID)%SSCNCR)
    DEALLOCATE (GWFLAKDAT(IGRID)%ICS)
    DEALLOCATE (GWFLAKDAT(IGRID)%NCNCVR)
    DEALLOCATE (GWFLAKDAT(IGRID)%LIMERR)
    DEALLOCATE (GWFLAKDAT(IGRID)%ILAKE)
    DEALLOCATE (GWFLAKDAT(IGRID)%ITRB)
    DEALLOCATE (GWFLAKDAT(IGRID)%IDIV)
    DEALLOCATE (GWFLAKDAT(IGRID)%ISUB)
    DEALLOCATE (GWFLAKDAT(IGRID)%IRK)
    DEALLOCATE (GWFLAKDAT(IGRID)%LKARR1)
    DEALLOCATE (GWFLAKDAT(IGRID)%STAGES)
    DEALLOCATE (GWFLAKDAT(IGRID)%FLOB)
    DEALLOCATE (GWFLAKDAT(IGRID)%DSRFOT)
    DEALLOCATE (GWFLAKDAT(IGRID)%PRCPLK)
    DEALLOCATE (GWFLAKDAT(IGRID)%EVAPLK)
    DEALLOCATE (GWFLAKDAT(IGRID)%BEDLAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%WTHDRW)
    DEALLOCATE (GWFLAKDAT(IGRID)%RNF)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMRNF)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMPPT)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMEVP)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMGWI)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMGWO)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMSWI)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMSWO)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMWDR)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMFLX)
    DEALLOCATE (GWFLAKDAT(IGRID)%CNDFCT)
    DEALLOCATE (GWFLAKDAT(IGRID)%VOLINIT)
    DEALLOCATE (GWFLAKDAT(IGRID)%BOTTMS)
    DEALLOCATE (GWFLAKDAT(IGRID)%BGAREA)
    DEALLOCATE (GWFLAKDAT(IGRID)%SSMN)
    DEALLOCATE (GWFLAKDAT(IGRID)%SSMX)
    DEALLOCATE (GWFLAKDAT(IGRID)%EVAP)
    DEALLOCATE (GWFLAKDAT(IGRID)%PRECIP)
    DEALLOCATE (GWFLAKDAT(IGRID)%EVAP3)
    DEALLOCATE (GWFLAKDAT(IGRID)%PRECIP3)
    DEALLOCATE (GWFLAKDAT(IGRID)%SEEP)
    DEALLOCATE (GWFLAKDAT(IGRID)%SEEP3)
    DEALLOCATE (GWFLAKDAT(IGRID)%SURFA)
    DEALLOCATE (GWFLAKDAT(IGRID)%SURFIN)
    DEALLOCATE (GWFLAKDAT(IGRID)%SURFOT)
    DEALLOCATE (GWFLAKDAT(IGRID)%SUMCNN)
    DEALLOCATE (GWFLAKDAT(IGRID)%SUMCHN)
    DEALLOCATE (GWFLAKDAT(IGRID)%CLAKE)
    DEALLOCATE (GWFLAKDAT(IGRID)%CRNF)
    DEALLOCATE (GWFLAKDAT(IGRID)%SILLVT)
    DEALLOCATE (GWFLAKDAT(IGRID)%CAUG)
    DEALLOCATE (GWFLAKDAT(IGRID)%CPPT)
    DEALLOCATE (GWFLAKDAT(IGRID)%CLAKINIT)
    DEALLOCATE (GWFLAKDAT(IGRID)%BDLKN1)
!Cdep  Added arrays that track lake budgets for dry lakes
    DEALLOCATE (GWFLAKDAT(Igrid)%EVAPO)
    DEALLOCATE (GWFLAKDAT(Igrid)%WITHDRW)
    DEALLOCATE (GWFLAKDAT(Igrid)%FLWIN)
    DEALLOCATE (GWFLAKDAT(Igrid)%FLWITER)
    DEALLOCATE (GWFLAKDAT(Igrid)%FLWITER3)
    DEALLOCATE (GWFLAKDAT(Igrid)%GWRATELIM)
!Cdep  Deallocate arrays used in conjunction with UZF Package
    DEALLOCATE (GWFLAKDAT(Igrid)%OVRLNDRNF)
    DEALLOCATE (GWFLAKDAT(Igrid)%CUMLNDRNF)
    DEALLOCATE (GWFLAKDAT(Igrid)%CUMUZF)
!Cdep  Deallocate arrays for storing depth, and area arrays
    DEALLOCATE (GWFLAKDAT(Igrid)%DEPTHTABLE)
    DEALLOCATE (GWFLAKDAT(Igrid)%AREATABLE)
    DEALLOCATE (GWFLAKDAT(Igrid)%VOLUMETABLE)
    DEALLOCATE (GWFLAKDAT(Igrid)%XLAKES)
    DEALLOCATE (GWFLAKDAT(Igrid)%XLAKINIT)
    DEALLOCATE (GWFLAKDAT(Igrid)%XLKOLD)
!Crsr allocate BD arrays
    DEALLOCATE (GWFLAKDAT(IGRID)%LDRY)
    DEALLOCATE (GWFLAKDAT(IGRID)%NCNT)
    DEALLOCATE (GWFLAKDAT(IGRID)%NCNST)
    DEALLOCATE (GWFLAKDAT(IGRID)%KSUB)
    DEALLOCATE (GWFLAKDAT(IGRID)%MSUB1)
    DEALLOCATE (GWFLAKDAT(IGRID)%MSUB)
    DEALLOCATE (GWFLAKDAT(IGRID)%FLXINL)
    DEALLOCATE (GWFLAKDAT(IGRID)%VOLOLD)
    DEALLOCATE (GWFLAKDAT(IGRID)%GWIN)
    DEALLOCATE (GWFLAKDAT(IGRID)%GWOUT)
    DEALLOCATE (GWFLAKDAT(IGRID)%DELH)
    DEALLOCATE (GWFLAKDAT(IGRID)%TDELH)
    DEALLOCATE (GWFLAKDAT(IGRID)%SVT)
    DEALLOCATE (GWFLAKDAT(IGRID)%STGADJ)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTGWIN_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTGWOT_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTDELSTOR_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTSTOR_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTEVAP_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTPPT_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTRUNF_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTWTHDRW_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTSURFIN_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%TOTSURFOT_LAK)
    DEALLOCATE (GWFLAKDAT(IGRID)%VOLOLDD)
!Cdep  Added arrays that calculate lake budgets 6/9/2009
    DEALLOCATE (GWFLAKDAT(IGRID)%DELVOL)
    DEALLOCATE (GWFLAKDAT(IGRID)%TSLAKERR)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMVOL)
    DEALLOCATE (GWFLAKDAT(IGRID)%CMLAKERR)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMLKIN)
    DEALLOCATE (GWFLAKDAT(IGRID)%CUMLKOUT)
    DEALLOCATE (GWFLAKDAT(IGRID)%LAKSEEP)
  END SUBROUTINE GWF2LAK7DA

  SUBROUTINE SGWF2LAK7PNT(IGRID)
!C  Set pointers to LAK data for grid
!C
    NLAKES=>GWFLAKDAT(IGRID)%NLAKES
    NLAKESAR=>GWFLAKDAT(IGRID)%NLAKESAR
    ILKCB=>GWFLAKDAT(IGRID)%ILKCB
    LAKTAB=>GWFLAKDAT(IGRID)%LAKTAB
    IRDTAB=>GWFLAKDAT(IGRID)%IRDTAB
    NeedLakWaterMover=>GWFLAKDAT(IGRID)%NeedLakWaterMover
    NSSITR=>GWFLAKDAT(IGRID)%NSSITR
    MXLKND=>GWFLAKDAT(IGRID)%MXLKND
    LKNODE=>GWFLAKDAT(IGRID)%LKNODE
    ICMX=>GWFLAKDAT(IGRID)%ICMX
    NCLS=>GWFLAKDAT(IGRID)%NCLS
    LWRT=>GWFLAKDAT(IGRID)%LWRT
    NDV=>GWFLAKDAT(IGRID)%NDV
    NTRB=>GWFLAKDAT(IGRID)%NTRB
    THETA=>GWFLAKDAT(IGRID)%THETA
    SSCNCR=>GWFLAKDAT(IGRID)%SSCNCR
!Cdep  added SURFDEPTH 3/3/2009
    SURFDEPTH=>GWFLAKDAT(IGRID)%SURFDEPTH
    ICS=>GWFLAKDAT(IGRID)%ICS
    NCNCVR=>GWFLAKDAT(IGRID)%NCNCVR
    LIMERR=>GWFLAKDAT(IGRID)%LIMERR
    ILAKE=>GWFLAKDAT(IGRID)%ILAKE
    ITRB=>GWFLAKDAT(IGRID)%ITRB
    IDIV=>GWFLAKDAT(IGRID)%IDIV
    ISUB=>GWFLAKDAT(IGRID)%ISUB
    IRK=>GWFLAKDAT(IGRID)%IRK
    LKARR1=>GWFLAKDAT(IGRID)%LKARR1
    STAGES=>GWFLAKDAT(IGRID)%STAGES
    STGNEW=>GWFLAKDAT(IGRID)%STGNEW
    STGOLD=>GWFLAKDAT(IGRID)%STGOLD
    STGOLD2=>GWFLAKDAT(IGRID)%STGOLD2
    STGITER=>GWFLAKDAT(IGRID)%STGITER
    VOL=>GWFLAKDAT(IGRID)%VOL
    FLOB=>GWFLAKDAT(IGRID)%FLOB
    DSRFOT=>GWFLAKDAT(IGRID)%DSRFOT
    PRCPLK=>GWFLAKDAT(IGRID)%PRCPLK
    EVAPLK=>GWFLAKDAT(IGRID)%EVAPLK
    BEDLAK=>GWFLAKDAT(IGRID)%BEDLAK
    WTHDRW=>GWFLAKDAT(IGRID)%WTHDRW
    RNF=>GWFLAKDAT(IGRID)%RNF
    CUMRNF=>GWFLAKDAT(IGRID)%CUMRNF
    CUMPPT=>GWFLAKDAT(IGRID)%CUMPPT
    CUMEVP=>GWFLAKDAT(IGRID)%CUMEVP
    CUMGWI=>GWFLAKDAT(IGRID)%CUMGWI
    CUMGWO=>GWFLAKDAT(IGRID)%CUMGWO
    CUMSWI=>GWFLAKDAT(IGRID)%CUMSWI
    CUMSWO=>GWFLAKDAT(IGRID)%CUMSWO
    CUMWDR=>GWFLAKDAT(IGRID)%CUMWDR
    CUMFLX=>GWFLAKDAT(IGRID)%CUMFLX
    CNDFCT=>GWFLAKDAT(IGRID)%CNDFCT
    VOLINIT=>GWFLAKDAT(IGRID)%VOLINIT
    BOTTMS=>GWFLAKDAT(IGRID)%BOTTMS
    BGAREA=>GWFLAKDAT(IGRID)%BGAREA
    SSMN=>GWFLAKDAT(IGRID)%SSMN
    SSMX=>GWFLAKDAT(IGRID)%SSMX
    EVAP=>GWFLAKDAT(IGRID)%EVAP
    PRECIP=>GWFLAKDAT(IGRID)%PRECIP
    EVAP3=>GWFLAKDAT(IGRID)%EVAP3
    PRECIP3=>GWFLAKDAT(IGRID)%PRECIP3
    SEEP=>GWFLAKDAT(IGRID)%SEEP
    SEEP3=>GWFLAKDAT(IGRID)%SEEP3
    SURFA=>GWFLAKDAT(IGRID)%SURFA
    SURFIN=>GWFLAKDAT(IGRID)%SURFIN
    SURFOT=>GWFLAKDAT(IGRID)%SURFOT
    SUMCNN=>GWFLAKDAT(IGRID)%SUMCNN
    SUMCHN=>GWFLAKDAT(IGRID)%SUMCHN
    CLAKE=>GWFLAKDAT(IGRID)%CLAKE
    CRNF=>GWFLAKDAT(IGRID)%CRNF
    SILLVT=>GWFLAKDAT(IGRID)%SILLVT
    CAUG=>GWFLAKDAT(IGRID)%CAUG
    CPPT=>GWFLAKDAT(IGRID)%CPPT
    CLAKINIT=>GWFLAKDAT(IGRID)%CLAKINIT
    BDLKN1=>GWFLAKDAT(IGRID)%BDLKN1
!Cdep  Added arrays that track lake budgets for dry lakes
    EVAPO=>GWFLAKDAT(Igrid)%EVAPO
    WITHDRW=>GWFLAKDAT(Igrid)%WITHDRW
    FLWIN=>GWFLAKDAT(Igrid)%FLWIN
    FLWITER=>GWFLAKDAT(Igrid)%FLWITER
    FLWITER3=>GWFLAKDAT(Igrid)%FLWITER3
    GWRATELIM=>GWFLAKDAT(Igrid)%GWRATELIM
!Cdep  added two variable arrays
    OVRLNDRNF=>GWFLAKDAT(Igrid)%OVRLNDRNF
    CUMLNDRNF=>GWFLAKDAT(Igrid)%CUMLNDRNF
    CUMUZF=>GWFLAKDAT(Igrid)%CUMUZF
!Cdep  added three variable arrays for depth,area, and volume
    DEPTHTABLE=>GWFLAKDAT(Igrid)%DEPTHTABLE
    AREATABLE=>GWFLAKDAT(Igrid)%AREATABLE
    VOLUMETABLE=>GWFLAKDAT(Igrid)%VOLUMETABLE
    XLAKES=>GWFLAKDAT(Igrid)%XLAKES
    XLAKINIT=>GWFLAKDAT(Igrid)%XLAKINIT
    XLKOLD=>GWFLAKDAT(Igrid)%XLKOLD
!Crsr allocate BD arrays
    LDRY=>GWFLAKDAT(IGRID)%LDRY
    NCNT=>GWFLAKDAT(IGRID)%NCNT
    NCNST=>GWFLAKDAT(IGRID)%NCNST
    KSUB=>GWFLAKDAT(IGRID)%KSUB
    MSUB1=>GWFLAKDAT(IGRID)%MSUB1
    MSUB=>GWFLAKDAT(IGRID)%MSUB
    FLXINL=>GWFLAKDAT(IGRID)%FLXINL
    VOLOLD=>GWFLAKDAT(IGRID)%VOLOLD
    GWIN=>GWFLAKDAT(IGRID)%GWIN
    GWOUT=>GWFLAKDAT(IGRID)%GWOUT
    DELH=>GWFLAKDAT(IGRID)%DELH
    TDELH=>GWFLAKDAT(IGRID)%TDELH
    SVT=>GWFLAKDAT(IGRID)%SVT
    STGADJ=>GWFLAKDAT(IGRID)%STGADJ
    TOTGWIN_LAK=>GWFLAKDAT(IGRID)%TOTGWIN_LAK
    TOTGWOT_LAK=>GWFLAKDAT(IGRID)%TOTGWOT_LAK
    TOTDELSTOR_LAK=>GWFLAKDAT(IGRID)%TOTDELSTOR_LAK
    TOTSTOR_LAK=>GWFLAKDAT(IGRID)%TOTSTOR_LAK
    TOTEVAP_LAK=>GWFLAKDAT(IGRID)%TOTEVAP_LAK
    TOTPPT_LAK=>GWFLAKDAT(IGRID)%TOTPPT_LAK
    TOTRUNF_LAK=>GWFLAKDAT(IGRID)%TOTRUNF_LAK
    TOTWTHDRW_LAK=>GWFLAKDAT(IGRID)%TOTWTHDRW_LAK
    TOTSURFIN_LAK=>GWFLAKDAT(IGRID)%TOTSURFIN_LAK
    TOTSURFOT_LAK=>GWFLAKDAT(IGRID)%TOTSURFOT_LAK
    LAKUNIT=>GWFLAKDAT(IGRID)%LAKUNIT
    VOLOLDD=>GWFLAKDAT(IGRID)%VOLOLDD
!Cdep  Allocate lake budget error arrays 6/9/2009
    DELVOL=>GWFLAKDAT(IGRID)%DELVOL
    TSLAKERR=>GWFLAKDAT(IGRID)%TSLAKERR
    CUMVOL=>GWFLAKDAT(IGRID)%CUMVOL
    CMLAKERR=>GWFLAKDAT(IGRID)%CMLAKERR
    CUMLKOUT=>GWFLAKDAT(IGRID)%CUMLKOUT
    CUMLKIN=>GWFLAKDAT(IGRID)%CUMLKIN
    LAKSEEP=>GWFLAKDAT(IGRID)%LAKSEEP
  END SUBROUTINE SGWF2LAK7PNT

  SUBROUTINE SGWF2LAK7PSV1(IGRID)
!C  Save LAK data for a grid for data shared with SFR
!C
    GWFLAKDAT(IGRID)%NLAKES=>NLAKES
    GWFLAKDAT(IGRID)%NLAKESAR=>NLAKESAR
    GWFLAKDAT(IGRID)%THETA=>THETA
    GWFLAKDAT(IGRID)%STGOLD=>STGOLD
    GWFLAKDAT(IGRID)%STGOLD2=>STGOLD2
    GWFLAKDAT(IGRID)%STGNEW=>STGNEW
    GWFLAKDAT(IGRID)%STGITER=>STGITER
    GWFLAKDAT(IGRID)%VOL=>VOL
    GWFLAKDAT(IGRID)%LAKUNIT=>LAKUNIT
  END SUBROUTINE SGWF2LAK7PSV1

  SUBROUTINE SGWF2LAK7PSV(IGRID)
!C  Save LAK data for a grid
!C
    GWFLAKDAT(IGRID)%ILKCB=>ILKCB
    GWFLAKDAT(IGRID)%NSSITR=>NSSITR
    GWFLAKDAT(IGRID)%MXLKND=>MXLKND
    GWFLAKDAT(IGRID)%LKNODE=>LKNODE
    GWFLAKDAT(IGRID)%ICMX=>ICMX
    GWFLAKDAT(IGRID)%LAKTAB=>LAKTAB
    GWFLAKDAT(IGRID)%IRDTAB=>IRDTAB
    GWFLAKDAT(IGRID)%NeedLakWaterMover=>NeedLakWaterMover
    GWFLAKDAT(IGRID)%NCLS=>NCLS
    GWFLAKDAT(IGRID)%LWRT=>LWRT
    GWFLAKDAT(IGRID)%NDV=>NDV
    GWFLAKDAT(IGRID)%NTRB=>NTRB
    GWFLAKDAT(IGRID)%SSCNCR=>SSCNCR
!Cdep  Added SURDEPTH 3/3/2009
    GWFLAKDAT(IGRID)%SURFDEPTH=>SURFDEPTH
    GWFLAKDAT(IGRID)%ICS=>ICS
    GWFLAKDAT(IGRID)%NCNCVR=>NCNCVR
    GWFLAKDAT(IGRID)%LIMERR=>LIMERR
    GWFLAKDAT(IGRID)%ILAKE=>ILAKE
    GWFLAKDAT(IGRID)%ITRB=>ITRB
    GWFLAKDAT(IGRID)%IDIV=>IDIV
    GWFLAKDAT(IGRID)%ISUB=>ISUB
    GWFLAKDAT(IGRID)%IRK=>IRK
    GWFLAKDAT(IGRID)%LKARR1=>LKARR1
    GWFLAKDAT(IGRID)%STAGES=>STAGES
    GWFLAKDAT(IGRID)%FLOB=>FLOB
    GWFLAKDAT(IGRID)%DSRFOT=>DSRFOT
    GWFLAKDAT(IGRID)%PRCPLK=>PRCPLK
    GWFLAKDAT(IGRID)%EVAPLK=>EVAPLK
    GWFLAKDAT(IGRID)%BEDLAK=>BEDLAK
    GWFLAKDAT(IGRID)%WTHDRW=>WTHDRW
    GWFLAKDAT(IGRID)%RNF=>RNF
    GWFLAKDAT(IGRID)%CUMRNF=>CUMRNF
    GWFLAKDAT(IGRID)%CUMPPT=>CUMPPT
    GWFLAKDAT(IGRID)%CUMEVP=>CUMEVP
    GWFLAKDAT(IGRID)%CUMGWI=>CUMGWI
    GWFLAKDAT(IGRID)%CUMGWO=>CUMGWO
    GWFLAKDAT(IGRID)%CUMSWI=>CUMSWI
    GWFLAKDAT(IGRID)%CUMSWO=>CUMSWO
    GWFLAKDAT(IGRID)%CUMWDR=>CUMWDR
    GWFLAKDAT(IGRID)%CUMFLX=>CUMFLX
    GWFLAKDAT(IGRID)%CNDFCT=>CNDFCT
    GWFLAKDAT(IGRID)%VOLINIT=>VOLINIT
    GWFLAKDAT(IGRID)%BOTTMS=>BOTTMS
    GWFLAKDAT(IGRID)%BGAREA=>BGAREA
    GWFLAKDAT(IGRID)%SSMN=>SSMN
    GWFLAKDAT(IGRID)%SSMX=>SSMX
    GWFLAKDAT(IGRID)%EVAP=>EVAP
    GWFLAKDAT(IGRID)%PRECIP=>PRECIP
    GWFLAKDAT(IGRID)%EVAP3=>EVAP3
    GWFLAKDAT(IGRID)%PRECIP3=>PRECIP3
    GWFLAKDAT(IGRID)%SEEP=>SEEP
    GWFLAKDAT(IGRID)%SEEP3=>SEEP3
    GWFLAKDAT(IGRID)%SURFA=>SURFA
    GWFLAKDAT(IGRID)%SURFIN=>SURFIN
    GWFLAKDAT(IGRID)%SURFOT=>SURFOT
    GWFLAKDAT(IGRID)%SUMCNN=>SUMCNN
    GWFLAKDAT(IGRID)%SUMCHN=>SUMCHN
    GWFLAKDAT(IGRID)%CLAKE=>CLAKE
    GWFLAKDAT(IGRID)%CRNF=>CRNF
    GWFLAKDAT(IGRID)%SILLVT=>SILLVT
    GWFLAKDAT(IGRID)%CAUG=>CAUG
    GWFLAKDAT(IGRID)%CPPT=>CPPT
    GWFLAKDAT(IGRID)%CLAKINIT=>CLAKINIT
    GWFLAKDAT(IGRID)%BDLKN1=>BDLKN1
!Cdep  Added arrays that track lake budgets for dry lakes
    GWFLAKDAT(Igrid)%EVAPO=>EVAPO
    GWFLAKDAT(Igrid)%WITHDRW=>WITHDRW
    GWFLAKDAT(Igrid)%FLWIN=>FLWIN
    GWFLAKDAT(Igrid)%FLWITER=>FLWITER
    GWFLAKDAT(Igrid)%FLWITER3=>FLWITER3
    GWFLAKDAT(Igrid)%GWRATELIM=>GWRATELIM
!Cdep  added two variable arrays
    GWFLAKDAT(Igrid)%OVRLNDRNF=>OVRLNDRNF
    GWFLAKDAT(Igrid)%CUMLNDRNF=>CUMLNDRNF
    GWFLAKDAT(Igrid)%CUMUZF=>CUMUZF
!Cdep  added three variable arrays for depth, area, and volume
    GWFLAKDAT(Igrid)%DEPTHTABLE=>DEPTHTABLE
    GWFLAKDAT(Igrid)%AREATABLE=>AREATABLE
    GWFLAKDAT(Igrid)%VOLUMETABLE=>VOLUMETABLE
    GWFLAKDAT(Igrid)%XLAKES=>XLAKES
    GWFLAKDAT(Igrid)%XLAKINIT=>XLAKINIT
    GWFLAKDAT(Igrid)%XLKOLD=>XLKOLD
!Crsr allocate BD arrays
    GWFLAKDAT(IGRID)%LDRY=>LDRY
    GWFLAKDAT(IGRID)%NCNT=>NCNT
    GWFLAKDAT(IGRID)%NCNST=>NCNST
    GWFLAKDAT(IGRID)%KSUB=>KSUB
    GWFLAKDAT(IGRID)%MSUB1=>MSUB1
    GWFLAKDAT(IGRID)%MSUB=>MSUB
    GWFLAKDAT(IGRID)%FLXINL=>FLXINL
    GWFLAKDAT(IGRID)%VOLOLD=>VOLOLD
    GWFLAKDAT(IGRID)%GWIN=>GWIN
    GWFLAKDAT(IGRID)%GWOUT=>GWOUT
    GWFLAKDAT(IGRID)%DELH=>DELH
    GWFLAKDAT(IGRID)%TDELH=>TDELH
    GWFLAKDAT(IGRID)%SVT=>SVT
    GWFLAKDAT(IGRID)%STGADJ=>STGADJ
!Cdep  Allocate lake budget error arrays 6/9/2009
    GWFLAKDAT(IGRID)%DELVOL=>DELVOL
    GWFLAKDAT(IGRID)%TSLAKERR=>TSLAKERR
    GWFLAKDAT(IGRID)%CUMVOL=>CUMVOL
    GWFLAKDAT(IGRID)%CMLAKERR=>CMLAKERR
    GWFLAKDAT(IGRID)%CUMLKOUT=>CUMLKOUT
    GWFLAKDAT(IGRID)%CUMLKIN=>CUMLKIN
!crgn Allocate budget arrays for GSFLOW CSV file
    GWFLAKDAT(IGRID)%TOTGWIN_LAK=>TOTGWIN_LAK
    GWFLAKDAT(IGRID)%TOTGWOT_LAK=>TOTGWOT_LAK
    GWFLAKDAT(IGRID)%TOTDELSTOR_LAK=>TOTDELSTOR_LAK
    GWFLAKDAT(IGRID)%TOTSTOR_LAK=>TOTSTOR_LAK
    GWFLAKDAT(IGRID)%TOTEVAP_LAK=>TOTEVAP_LAK
    GWFLAKDAT(IGRID)%TOTPPT_LAK=>TOTPPT_LAK
    GWFLAKDAT(IGRID)%TOTRUNF_LAK=>TOTRUNF_LAK
    GWFLAKDAT(IGRID)%TOTWTHDRW_LAK=>TOTWTHDRW_LAK
    GWFLAKDAT(IGRID)%TOTSURFIN_LAK=>TOTSURFIN_LAK
    GWFLAKDAT(IGRID)%TOTSURFOT_LAK=>TOTSURFOT_LAK
    GWFLAKDAT(IGRID)%VOLOLDD=>VOLOLDD
    GWFLAKDAT(IGRID)%LAKSEEP=>LAKSEEP
  END SUBROUTINE SGWF2LAK7PSV

END MODULE GWFLAKMODULE

! Scalar variables:
!
! ICMX      
! ILKCB     Unit # for cell-by-cell flows
! IRDTAB    =1 for TABLEINPUT option, otherwise 0
! LAKUNIT   Unit # for LAK input file
! LKNODE    
! LWRT      
! MXLKAR    SPACE FOR FLOB ARRAY WHEN TRANSPORT ACTIVE.
! MXLKND    NUMBER OF LAKE-AQUIFER INTERFACES (AN ESTIMATE)
! NCLS      
! NDV       
! NLAKES    Number of lakes
! NLAKESAR  Number of lakes for allocating arrays, but not < 1
! NSOL      Number of solutes from GWT
! NSS       From GWFSFRMODULE, = number of stream segments
! NSSAR     SPACE FOR CONNECTION WITH STREAMS
! NSSITR    Maximum number of iterations for solution for lake stage
! NTRB      
! NUZFAR    SPACE FOR OVERLAND FLOW WHEN UNSATURATED FLOW ACTIVE
! SSCNCR    Convergence criterion for equilibrium lake stage solution
! SURFDEPTH The height of small topological variations in lake-bottom elevations
! THETA     Time-weighting factor for solving for lake stage
! TOTGWIN_LAK, TOTGWOT_LAK, TOTDELSTOR_LAK, TOTSTOR_LAK
! TOTEVAP_LAK, TOTPPT_LAK, TOTRUNF_LAK, TOTWTHDRW_LAK
! TOTSURFIN_LAK, TOTSURFOT_LAK
! 
! Arrays:
!
! AREATABLE(151,NLAKES)
! BEDLAK(MXLKND)
! BDLKN1(NCOL,NROW,NLAY)
! BOTTMS(NLAKES)
! BGAREA(NLAKES)
! CAUG(NLAKES,NSOL)          concentration of solute in water used to augment the lake volume
! CLAKE(NLAKESAR,NSOL)       concentration in lake, all solutes
! CLAKINIT(NLAKESAR,NSOL)
! CMLAKERR(NLAKES)
! CNDFCT(MXLKND)
! CPPT(NLAKES,NSOL)          concentration of solute in precipitation onto the lake surface
! CRNF(NLAKES,NSOL)          concentration of solute in overland runoff directly into the lake
! CUMRNF(NLAKES)
! CUMUZF(NLAKES)
! CUMPPT(NLAKES)
! CUMEVP(NLAKES)
! CUMGWI(NLAKES)
! CUMGWO(NLAKES)
! CUMSWI(NLAKES)
! CUMSWO(NLAKES)
! CUMWDR(NLAKES)
! CUMFLX(NLAKES)
! CUMVOL(NLAKES),
! CUMLKIN(NLAKES)
! CUMLKOUT(NLAKES)
! CUMLNDRNF(NUZFAR)
! DELH(NLAKES)
! DELVOL(NLAKES)
! DEPTHTABLE(151,NLAKES)
! DSRFOT(NLAKES)
! EVAPO(NLAKES)
! EVAPLK(NLAKES)             Rate of evaporation per unit area from the surface of a lake
! EVAP(NLAKES)
! EVAP3(NLAKES)
! FLOB(MXLKAR)
! FLWITER(NLAKES),FLWITER3(NLAKES)
! FLWIN(NLAKES)
! FLXINL(NLAKES)
! GWIN(NLAKES)
! GWOUT(NLAKES)
! GWRATELIM(NLAKES)
! IDIV(NLAKES,NSSAR)
! ILAKE(5,MXLKND)
! IRK(2,NLAKES)
! ICS(NLAKES)
! ISUB(NLAKES,NLAKES)        Identification numbers of the sublakes
! ITRB(NLAKES,NSSAR)
! KSUB(NLAKES)
! LAKSEEP(NCOL,NROW)
! LAKTAB(NLAKES)             Unit number of file of relations among lake stage, surface area, and volume.
! LIMERR(NLAKES)
! LKARR1(NCOL,NROW,NLAY)     Identification number of the lake occupying the grid cell
! LDRY(NODES)
! MSUB(NLAKES,NLAKES)
! MSUB1(NLAKES)
! NCNCVR(NLAKES)
! NCNT(NLAKES)
! NCNST(NLAKES)
! OVRLNDRNF(NUZFAR)
! PRCPLK(NLAKES)             Rate of precipitation per unit area at the surface of a lake
! PRECIP(NLAKES)
! PRECIP3(NLAKES)
! RNF(NLAKES)                Overland runoff from an adjacent watershed entering the lake
! SEEP(NLAKES),
! SEEP3(NLAKES)
! SEEPUZ(NLAKES)
! SILLVT(NLAKES,NLAKES)      Sill elevation for connection to a sublake
! SSMN(NLAKES)               Minimum stage for lake in steady-state solution
! SSMX(NLAKES)               Maximum stage for lake in steady-state solution
! SUMCNN(NLAKES)
! SUMCHN(NLAKES)
! SURFA(NLAKES)
! SURFIN(NLAKES)
! SURFOT(NLAKES)
! SVT(NLAKES)
! STAGES(NLAKESAR)           Lake stage
! STGITER(NLAKESAR)
! STGOLD(NLAKESAR)
! STGNEW(NLAKESAR)
! STGOLD2(NLAKESAR)
! STGADJ(NLAKES)
! TDELH(NLAKES)
! TSLAKERR(NLAKES)
! VOL(NLAKESAR)
! VOLOLD(NLAKES)
! VOLINIT(NLAKES)
! VOLOLDD(NLAKESAR)
! VOLUMETABLE(151,NLAKES)
! WTHDRW(NLAKES)             volumetric rate, or flux (L3/T), of water removal from a lake by means other than rainfall, evaporation, surface outflow, or ground-water seepage. A negative value indicates augmentation.
! WITHDRW(NLAKES)
! Three arrays used in GAGE Package when Solute Transport is active:
! XLAKES(NLAKES,1), XLAKINIT(NLAKES,1), XLKOLD(NLAKES,1)
