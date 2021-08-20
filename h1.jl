using Pipe: @pipe
using QuadGK

const γ = 1.4
const D = 0.208 * 1e-4
const ρ = 998
const σ = 0.0725
const p∞ = 101325
const μ = 0.00102
const c0 = 1540
const n = -3
#const 𝐿 = 0.5
const 𝑎_min = 10e-6
const 𝑎_max = 300e-6
const ω_0 = 2π*24e3
const k0 = ω_0/c0
#const η = 1e-5

χ(ω, 𝑎) = D/(ω*(𝑎^2))
ϕ(χ) = @pipe (3*(γ -1)*1im*χ) |> _*  ( (1im/χ)^(0.5)*coth(((1im/χ)^0.5))  -1 )  |> 1 - _ |> 3γ/_
ω0(ω, 𝑎) =  @pipe p∞ + 2σ/𝑎 |> (_/(ρ*𝑎^2)) *real(ϕ(   χ(ω,𝑎)   )) - (2σ / (𝑎*_) ) |> sqrt(Complex(_))
δ0(ω, 𝑎) = @pipe p∞ + 2σ/𝑎 |> (2μ/(ρ*𝑎^2)) + _/(2ω*ρ*𝑎^2) * imag(ϕ(χ(ω,𝑎))) + 𝑎*ω^2/(2c0)  |> 2*_/ω

f0(a) = a^3 *a^n 
n0(𝑎_min, 𝑎_max, η) =  @pipe quadgk(f0, 𝑎_min, 𝑎_max) |> 3/4*η/pi/_[1]  
na(𝑎, n_0, z, 𝐿) = n_0 * 𝑎^(n) * exp(-z/𝐿) 
ha(ω, 𝑎) = 4π*𝑎 / ((ω0(ω, 𝑎)/ω)^2 - 1 + 1im * (δ0(ω, 𝑎)))
hana(𝑎, z, n_0, 𝐿) =  ha(ω_0, 𝑎) * na(𝑎, n_0, z, 𝐿)

function bb_ssp_depth(depth, η, 𝐿)
    n_0=n0(𝑎_min, 𝑎_max, η)
    cm = zeros(length(depth))
    for (i, z) = enumerate(depth)
        func(𝑎) = hana(𝑎, z, n_0, 𝐿)  
        intg=quadgk(func, 𝑎_min, 𝑎_max)
        km = k0 + 1/(2*k0)*intg[1]
        cm[i] =ω_0/real(km)
    end
    cm
end