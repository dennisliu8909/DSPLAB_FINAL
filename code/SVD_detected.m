function watermark_out = SVD_detected(target_HH2, Uw, Vw)
    [u1, s1, v1] = svd(target_HH2);
    sz = size(s1);
    pad = 128 - sz(1);
    s1 = [s1, zeros(sz(1),pad); zeros(pad,sz(1)), zeros(pad,pad)];

    watermark_out = Uw*s1*Vw';
    watermark_out = imbinarize(watermark_out);
    
end