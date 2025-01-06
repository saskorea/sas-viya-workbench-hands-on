   _ngbys_ = 1;
   _igby_ = 0;
   _tnn_ntrans_ = 1;

   _fuzcmp_ = 2.22044604925e-10;

   array _tnn_vnames_{8}  _temporary_ ;
   _tnn_vnames_{1} = BIN_AGE;
   _tnn_vnames_{2} = BIN_SAL_AM;
   _tnn_vnames_{3} = BIN_TNR_DD;
   _tnn_vnames_{4} = BIN_ENG_SCR;
   _tnn_vnames_{5} = BIN_SAT_SCR;
   _tnn_vnames_{6} = BIN_PRJ_CN;
   _tnn_vnames_{7} = BIN_LT_DD;
   _tnn_vnames_{8} = BIN_ABSN;

   array _vnn_names_{8} _temporary_;
   _vnn_names_{1} = ABSN;
   _vnn_names_{2} = AGE;
   _vnn_names_{3} = ENG_SCR;
   _vnn_names_{4} = LT_DD;
   _vnn_names_{5} = PRJ_CN;
   _vnn_names_{6} = SAL_AM;
   _vnn_names_{7} = SAT_SCR;
   _vnn_names_{8} = TNR_DD;

   array _tnn_ntransvars_{1}  _temporary_   (8 );

   array _tv_nn_indices_{8}  _temporary_   (2 6 8 3 7 5 4 1 );

   BIN_AGE = .;
   BIN_SAL_AM = .;
   BIN_TNR_DD = .;
   BIN_ENG_SCR = .;
   BIN_SAT_SCR = .;
   BIN_PRJ_CN = .;
   BIN_LT_DD = .;
   BIN_ABSN = .;

   array _tnn_binttype_{1}   _temporary_   (2 );

   array _tnn_special_bins_{1}   _temporary_   (5 );
   array _missing_special_{3}   _temporary_   (1 4 5);
   array _outlier_special_{2}   _temporary_   (2 4);
   array _no_data_lb_ub_special_{2}   _temporary_   (3 5);

   array _tnn_bin_mapping_{1}   _temporary_   (0 );



   array _tnn_nbinsirreg_{8}   _temporary_   (14 13 15 12 3 3 2 12 );

   array _tnn_nbinsirreg_pre_gby_sum_{1}   _temporary_   (0 );

   array _tnn_binsirregcutmaps_{164}   _temporary_   (-8.9884656743116E307 1 29.28 2
      30.1 3 31.33 4 33.38 5 34.2 6 35.02 7 37.07 8 40.35 9 42.4 10 44.04 11 47.32 12
      49.37 13 53.06 14 8.9884656743115E307 -1 -8.9884656743116E307 1 5651.4648 2
      6143.3544 3 6389.2992 4 6881.1888 5 7127.1336 6 7373.0784 7 7619.0232 8 7864.968
      9 8110.9128 10 8848.7472 11 10078.4712 12 11800.0848 13 8.9884656743115E307 -1
      -8.9884656743116E307 1 591.56 2 780.08 3 968.6 4 1298.51 5 1392.77 6 1487.03 7
      1581.29 8 1675.55 9 1816.94 10 1911.2 11 2193.98 12 2382.5 13 2523.89 14 2712.41
      15 8.9884656743115E307 -1 -8.9884656743116E307 1 3.02119999999999 2
      3.25399999999999 3 3.56439999999999 4 3.79719999999999 5 4.02999999999999 6
      4.14639999999999 7 4.26279999999999 8 4.49559999999999 9 4.53439999999999 10
      4.68959999999999 11 4.8448 12 8.9884656743115E307 -1 -8.9884656743116E307 1 3.04
      2 4.04 3 8.9884656743115E307 -1 -8.9884656743116E307 1 4.08 2 5.04 3
      8.9884656743115E307 -1 -8.9884656743116E307 1 3.06 2 8.9884656743115E307 -1
      -8.9884656743116E307 1 2.14 2 3.09 3 4.04 4 6.13 5 8.02999999999999 6 10.12 7
      12.02 8 13.16 9 14.11 10 15.06 11 17.15 12 8.9884656743115E307 -1 );



   _ct_ = 0;
   _trimmed_ = 0;
   _nbinsirregct_ = 8 * _igby_;
   _binsirreglbubct_ = _tnn_nbinsirreg_pre_gby_sum_{_igby_ + 1};

   do _i_ = 1 to _tnn_ntrans_;
      do _j_ = 1 to _tnn_ntransvars_{_i_};

         _ct_ + 1;
         _numval_ = _vnn_names_{_tv_nn_indices_{_ct_}};

         if _tnn_binttype_{_i_} ne 0 then
            do;
               if _tnn_binttype_{_i_} = 2 then
                  do;
                     _nbinsirregct_ + 1;
                     _nbins_ = _tnn_nbinsirreg_{_nbinsirregct_};
                     _lb_ = _tnn_binsirregcutmaps_{_binsirreglbubct_ + 1};
                     _ub_ = _tnn_binsirregcutmaps_{_binsirreglbubct_ + 2*_nbins_ + 1};
                     _binsirreglbubct_ + 2*(_nbins_ + 1);
                  end;
               _special_bin_ = 0;
               if (missing(_numval_) & (_trimmed_ = 0) &
                  (_tnn_special_bins_{_i_} in (1 4 5))) then
                  do;
                     _numval_ = 0;
                     _special_bin_ = 1;
                  end;
               else if (missing(_numval_) & (_trimmed_ = 1) &
                  (_tnn_special_bins_{_i_} in (2 4))) then
                  do;
                     _numval_ = _nbins_ + 1;
                     _special_bin_ = 1;
                  end;
               else if (missing(_numval_) & (_trimmed_ = 2) &
                  (_tnn_special_bins_{_i_} in (2 4))) then
                  do;
                     _numval_ = _nbins_ + 2;
                     _special_bin_ = 1;
                  end;
               else if (missing(_numval_) &
                  (_tnn_special_bins_{_i_} in (1 4 5))) then
                  do;
                     _numval_ = 0;
                     _special_bin_ = 1;
                  end;
               else if (missing(_numval_)) then
                  do;
                     _numval_ = .;
                     _special_bin_ = 0;
                  end;
               else if ((_numval_ < (_lb_ - _fuzcmp_)) &
                  (_tnn_special_bins_{_i_} in (2 4))) then
                  do;
                     _numval_ = _nbins_ + 1;
                     _special_bin_ = 1;
                  end;
               else if ((_numval_ > (_ub_ + _fuzcmp_)) &
                  (_tnn_special_bins_{_i_} in (2 4))) then
                  do;
                     _numval_ = _nbins_ + 2;
                     _special_bin_ = 1;
                  end;
               else if ((_numval_ < (_lb_ - _fuzcmp_)) &
                  (_tnn_special_bins_{_i_} in (3 5))) then
                  do;
                     _numval_ = 1;
                     _special_bin_ = 1;
                  end;
               else if ((_numval_ > (_ub_ + _fuzcmp_)) &
                  (_tnn_special_bins_{_i_} in (3 5))) then
                  do;
                     _numval_ = _nbins_;
                     _special_bin_ = 1;
                  end;
               else _special_bin_ = 0;
               if ((_special_bin_ = 1 ) | (missing(_numval_))) then goto _tnn_done1_;
               if _tnn_binttype_{_i_} = 2 then
                  do;
                     _binsirreglbubct_ = _binsirreglbubct_ - 2*(_nbins_ + 1);
                     _binsirreglbubct_ + 1;
                     _low_ = 1;
                     _high_ = _nbins_ - 1;
                     _klow_ = _binsirreglbubct_ + 2*_low_;
                     _khigh_ = _binsirreglbubct_ + 2*_high_;
                     if _tnn_bin_mapping_{_i_} = 0 then _fuzfac_ = 1;
                     else _fuzfac_ = -1;
                     if (_numval_ >= (_tnn_binsirregcutmaps_{_khigh_} - _fuzfac_ * _fuzcmp_)) then
                        _binindex_ = _high_ + 1;
                     else if (_numval_ < (_tnn_binsirregcutmaps_{_klow_} - _fuzfac_ * _fuzcmp_)) then
                        _binindex_ = _low_;
                     else
                        do;
                           do while(_high_ > (_low_ + 1));
                              _mid_ = int((_low_ + _high_)/2);
                              _k_ = _binsirreglbubct_ + 2*(_mid_ - 1);
                              if (_numval_ < (_tnn_binsirregcutmaps_{_k_} -  _fuzfac_ * _fuzcmp_)) then
                                 _high_ = _mid_;
                              else _low_ = _mid_;
                           end;
                           _khigh_ = _binsirreglbubct_ + 2*_high_;
                           _klow_ = _binsirreglbubct_ + 2*_low_;
                           if (_numval_ >= (_tnn_binsirregcutmaps_{_khigh_} -  _fuzfac_ * _fuzcmp_)) then
                              _binindex_ = _high_ + 1;
                           else if ((_numval_ >= (_tnn_binsirregcutmaps_{_klow_} - _fuzfac_ * _fuzcmp_)) &
                                   (_numval_ < (_tnn_binsirregcutmaps_{_khigh_} - _fuzfac_ * _fuzcmp_))) then
                              _binindex_ = _high_;
                           else _binindex_ = _low_;
                        end;
                     _mapi_ = _binsirreglbubct_ + 2*(_binindex_ - 1) + 1;
                     _numval_ = _tnn_binsirregcutmaps_{_mapi_};
                     _binsirreglbubct_ + 2*(_nbins_ + 1) - 1;
                  end;
            end;
         _tnn_done1_:
            _tnn_vnames_{_ct_} = _numval_;
      end;
   end;

   BIN_AGE = _tnn_vnames_{1};
   BIN_SAL_AM = _tnn_vnames_{2};
   BIN_TNR_DD = _tnn_vnames_{3};
   BIN_ENG_SCR = _tnn_vnames_{4};
   BIN_SAT_SCR = _tnn_vnames_{5};
   BIN_PRJ_CN = _tnn_vnames_{6};
   BIN_LT_DD = _tnn_vnames_{7};
   BIN_ABSN = _tnn_vnames_{8};
   drop _ngbys_ _igby_ _tnn_ntrans_ _fuzcmp_ _ct_ _trimmed_ _nbinsirregct_
      _binsirreglbubct_ _i_ _j_ _numval_ _nbins_ _lb_ _ub_ _special_bin_ _low_ _high_
      _klow_ _khigh_ _fuzfac_ _mid_ _k_ _binindex_ _mapi_ ;


