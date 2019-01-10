function avw = create_avw(dim,pixdims)
% function avw = create_avw(dim,pixdims)
%
% Create an empty analyze image structure
% with specified voxel dimensions and pixel sizes.
%
% (C)opyright 2005, Bennett Landman, bennett@bme.jhu.edu
% Revision History:
% Created: 2/11/2005

%% HDR
avw.hdr.hk.sizeof_hdr=348;
avw.hdr.hk.db_name = '                  ';
avw.hdr.hk.extents = 0;
avw.hdr.hk.session_error = 0;
avw.hdr.hk.regular = ' ';
avw.hdr.hk.hkey_un0 = 32;
avw.hdr.hk.data_type = '          ';

%% DIME
avw.hdr.dime.dim = [4 dim 1 0 0 0];
avw.hdr.dime.vox_units = 'mm  ';
avw.hdr.dime.cal_units = '        ';
avw.hdr.dime.unused1 = 0;
avw.hdr.dime.datatype = 2;
avw.hdr.dime.bitpix = 8;
avw.hdr.dime.dim_un0 = 0;
avw.hdr.dime.pixdim = [1 pixdims 0 0 0 0 0];
avw.hdr.dime.vox_offset = 0;
avw.hdr.dime.roi_scale = 0;
avw.hdr.dime.funused1 = 0;
avw.hdr.dime.funused2 = 0;
avw.hdr.dime.cal_max = 0;
avw.hdr.dime.cal_min = 0;
avw.hdr.dime.compressed = 0;
avw.hdr.dime.verified = 0;
avw.hdr.dime.glmax = 2;
avw.hdr.dime.glmin = 0;

%% HIST
avw.hdr.hist.descrip = '                                                                                ';
avw.hdr.hist.aux_file = '                        ';
avw.hdr.hist.orient = 0;
avw.hdr.hist.originator = char([0 0 0 0 0 0 0 0 0 0]);
avw.hdr.hist.generated = '          ';
avw.hdr.hist.scannum = '          ';
avw.hdr.hist.patient_id = '          ';
avw.hdr.hist.exp_date = '          ';
avw.hdr.hist.exp_time = '          ';
avw.hdr.hist.hist_un0 = '   ';
avw.hdr.hist.views = 0;
avw.hdr.hist.vols_added = 0;
avw.hdr.hist.start_field = 0;
avw.hdr.hist.field_skip = 0;
avw.hdr.hist.omax = 0;
avw.hdr.hist.omin = 0;
avw.hdr.hist.smax = 0;
avw.hdr.hist.smin = 0;

avw.img = zeros(dim,'uint8');
