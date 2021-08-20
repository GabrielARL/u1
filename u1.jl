using DelimitedFiles
include("h1.jl")
time_diff = readdlm("time_diff.csv", ',')
const depth_b = 9.0
const depth_c = 22.0
const depth_modem_c = 2.5
using UnderwaterAcoustics, Plots

drange = 0:0.01:30
η = 3e-8
𝐿 = 0.15

env = UnderwaterEnvironment(
  seasurface = SeaState2,
  seabed = SandyClay,
  ssp = SampledSSP(drange, bb_ssp_depth(drange,η, 𝐿), :smooth),
  bathymetry = SampledDepth(0.0:300.0:616.0, [9.0, 15.5, 22.0], :linear)
)
pm = RaySolver(env; nbeams=2000, minangle = -80°, maxangle = 80°, atol = 1e-3, ds = 1, solvertol = 1e-3)
Tx = AcousticSource(0.0, -depth_b, 18000.0)
Rx = AcousticReceiver(616.0, -depth_modem_c)     
r = eigenrays(pm, Tx, Rx)
times = Array{Float64}(undef,0)
for (j, eigenray) ∈ enumerate(r)
  push!(times, eigenray.time)
end
idx = sortperm(times)
r = r[idx]
rr = filter(r1->(r1.surface == 1 && r1.bottom == 0)||(r1.surface==0 && r1.bottom==0), r)
if(length(rr) <= 1)
  diff_time = 0;
else
  diff_time = rr[2].time - rr[1].time 
end
plot(env; sources=[Tx], receivers=[Rx], rays = [r[1], r[2], r[3]])





