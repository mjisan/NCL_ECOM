
; This script is written for visualizing outputs from NYHOPS system
; From: Mansur Ali Jisan
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   

begin

 filename="gcmplt.cdf"
 f_coarse        = addfile (filename, "r")
 temp1     = f_coarse->elev
  temp1@lon2d=f_coarse->lon
  temp1@lat2d=f_coarse->lat

temp = (temp1*0.0003052037)


  wks  = gsn_open_wks("x11","WL")  ; send graphics to PNG file
  
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
  res@tiMainString  = "Water Level (m)"

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

  res@mpOutlineOn           = True
  res@mpLandFillColor       = "tan"

  res@pmTickMarkDisplayMode = "Always"     ; Nicer tickmarks


do nt=0,200,2

  cmd=systemfunc("date -u -d '20121022 00 +"+nt+" hours' "+"'+%Y%m%d %H'")
  print(cmd)

  txres               = True                      ; text mods desired
  txres@txFontHeightF = 0.030                     ; text font height

  gsn_text_ndc(wks,cmd,.47,.85,txres)



res@cnFillOn        = True
res@cnLinesOn       = False
;res@cnLevelSelectionMode        = "ManualLevels"   ; set manual contour levels
;res@cnMinLevelValF              = -2               ; set min contour level
;res@cnMaxLevelValF              = 5               ; set max contour level
;res@cnLevelSpacingF             = 0.5                ;
res@lbOrientation   = "vertical"

res@gsnRightString = "meters"
plot1 = gsn_csm_contour_map_ce(wks,(temp(40,:,:)-temp(1,:,:)),res)

draw(plot1)
frame(wks)
end do

end
