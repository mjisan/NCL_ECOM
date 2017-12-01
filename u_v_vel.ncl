; This script is written for visualizing outputs from NYHOPS system
; From: Mansur Ali Jisan
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   

begin

 filename="gcmplt.cdf"
 f_coarse        = addfile (filename, "r")
 temp1     = f_coarse->u
  temp1@lon2d=f_coarse->lon
  temp1@lat2d=f_coarse->lat

temp2 = (temp1* 0.0001831222)

temp3     = f_coarse->v
  temp3@lon2d=f_coarse->lon
  temp3@lat2d=f_coarse->lat

temp4 = (temp3* 0.0001831222)


temp6 = sqrt(temp2^2 + temp4^2)
temp = temp6*100
  wks  = gsn_open_wks("png","temp")  ; send graphics to PNG file
  
  gsn_define_colormap(wks,"BlAqGrYeOrRevi200")

temp_max=max(temp)
  temp_min=min(temp)
  a1D      = ndtooned(temp)
  dsizes_a = dimsizes(temp)
;---Resolve the 1D indices back to their original 3D array.
  indices  = ind_resolve(maxind(a1D),dsizes_a)
  print(indices)
  print(temp_max)

  res                       = True
  res@gsnMaximize           = True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@tiMainString  = "FLOW (with hurricane - control case)"

res@tiMainFontColor = 1
  res@sfXArray        = temp1@lon2d
  res@sfYArray        = temp1@lat2d
  res@gsnAddCyclic    = False


res@mpMinLatF       = min(temp1@lat2d)
  res@mpMaxLatF       = max(temp1@lat2d)
  res@mpMinLonF       = min(temp1@lon2d)
  res@mpMaxLonF       = max(temp1@lon2d)

 res@mpLimitMode= "Corners"
 res@mpLeftCornerLatF      =  40.55                ; lat2d(0,0)
  res@mpLeftCornerLonF      = -74.15                ; lon2d(0,0)
  res@mpRightCornerLatF     = 40.8               ; lat2d(nlat-1,nlon-1)
  res@mpRightCornerLonF     = -73.85



res@mpGeophysicalLineThicknessF = 1.5


  res@mpDataBaseVersion     = "HighRes"
  res@mpOutlineBoundarySets = "GeophysicalAndUSStates"

  ;res@mpOutlineBoundarySets = "National"
;  res@mpOutlineSpecifiers   = (/ "United States", "Mexico", "Canada"/) + " : States"

  res@mpOutlineOn           = True
  res@mpLandFillColor       = "tan"

  res@pmTickMarkDisplayMode = "Always"     ; Nicer tickmarks


do nt=0,864,6

  cmd=systemfunc("date -u -d '18210903 00 +"+nt+" hours' "+"'+%Y%m%d %H'")
  print(cmd)

  txres               = True                      ; text mods desired
  txres@txFontHeightF = 0.030                     ; text font height

; note that a colon is the default function code, but since I have personally
; set the default code to be a tilde (~) in my .hluresfile, I manually
; reset it here, since the colon makes for a cleaner example.
;  txres@txFuncCode    = ":"

  gsn_text_ndc(wks,cmd,.47,.85,txres)
;   gsn_add_text(wks,cmd,.23,.5,txres)


res@cnFillOn        = True
res@cnLinesOn       = False
res@cnLevelSelectionMode        = "ManualLevels"   ; set manual contour levels
res@cnMinLevelValF              = 5               ; set min contour level
res@cnMaxLevelValF              = 100              ; set max contour level
res@cnLevelSpacingF             = 5                ;
res@lbOrientation   = "vertical"

res@gsnRightString = "cm/s"
plot1 = gsn_csm_contour_map_ce(wks,(temp(nt,1,:,:)),res)

draw(plot1)
frame(wks)
end do



end
