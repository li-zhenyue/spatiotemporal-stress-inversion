function type = StressType( s1_plunge, s2_plunge, s3_plunge )
% 参照Zoback(1992)的方法判断应力类型
% 单位：度
% type: NF，正断型；NS，正走滑型；SS，走滑型；TS，逆走滑型；TF，逆断型；U，不确定型

if s1_plunge >= 52 && s3_plunge <= 35
    type = 'NF';
elseif s1_plunge >= 40 && s1_plunge <= 52 && s3_plunge <= 20
    type = 'NS';
elseif ( s1_plunge <= 20 && s2_plunge >= 45 && s3_plunge <  40  ) || ...
       ( s1_plunge < 40  && s2_plunge >= 45 && s3_plunge <= 20 )
    type = 'SS';
elseif s1_plunge <= 20 && s3_plunge >= 40 && s3_plunge <= 52
    type = 'TS';
elseif s1_plunge <= 35 && s3_plunge >= 52
    type = 'TF';
else
    type = 'U';
end


end