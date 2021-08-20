X = output

out = similar(X)

R =CartesianIndices(X)
Ifirst, Ilast = first(R), last(R)
I1 = oneunit(Ifirst)

for I ∈ R
    ave = 0;
    count = 0;
    for j ∈ max(Ifirst, I-I1):min(Ilast,I+I1)
        if(ismissing(X[j]) == false)
            ave += X[j]
            count += 1 
        end
    end
    ave = ave/count
    X[I] = ave    
end



