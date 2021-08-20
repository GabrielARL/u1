using DelimitedFiles
include("h1.jl")
time_diff = readdlm("time_diff.csv", ',')
const depth_b = 9.0
const depth_c = 22.0
const depth_modem_c = 2.5
using UnderwaterAcoustics, Plots
using FileIO, JLD2
global prev_diff_time = 0

function  time_diff_1st_2nd( η, 𝐿 )
    drange = 0:0.01:30
    env = UnderwaterEnvironment(
    seasurface = SeaState2,
    seabed = SandyClay,
    ssp = SampledSSP(drange, bb_ssp_depth(drange, η, 𝐿), :smooth),
    bathymetry = SampledDepth(0.0:300.0:616.0, [9.0, 15.5, 22.0], :linear)
    )

    pm = RaySolver(env; nbeams=2000, minangle = -80°, maxangle = 80°, atol = 1e-3, ds = 1, solvertol = 1e-3)
    Tx = AcousticSource(0.0, -depth_b, 18000.0)
    Rx = AcousticReceiver(616.0, -depth_modem_c)     
    r = eigenrays(pm, Tx, Rx)

    times = Array{Union{Float64, Missing}}(undef,0)
    diff_time = Union{Float64, Missing}[]
    for (j, eigenray) ∈ enumerate(r)
      push!(times, eigenray.time)
    end
    
    idx = sortperm(times)
    r = r[idx]
    
    rr = filter(r1->(r1.surface == 1 && r1.bottom == 0)||(r1.surface==0 && r1.bottom==0), r)
    if(length(rr) <= 1)
      diff_time = missing
    else
      diff_time = rr[2].time - rr[1].time 
      prev_diff_time = diff_time
    end
    diff_time 
end

vf_range = 10 .^(range(-8,stop=-3,length=1000))
L_range = 0.05:0.01:0.99
output = Array{Union{Float64, Missing}}(missing, length(vf_range), length(L_range) )
for (i, vf) ∈ enumerate(vf_range)
    for (j, L) ∈ enumerate(L_range)
        println(i, j)
        output[i, j] = time_diff_1st_2nd( vf, L )
    end
end






