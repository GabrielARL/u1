# using PaddedViews
# using Statistics
# using Printf
# using Revise
# using PaddedViews

# # Base.:isreal(::Missing) = false
# # Base.:isreal(::Nothing) = false

 X = output
# P = Array{Float64}(undef, size(X,1), size(X,2))
# Xp = PaddedView(missing, X, (0:size(X,1)+1, 0:size(X,2)+1))
# P = parent(Xp)

# global ave = Union{Bool, Float64}

# function meanX(Xp, i, j)
#     ave = false
#     if(i >= 1 && j >=1 && i<= size(Xp, 1) && j<= size(Xp, 2))
#      X1 = @view Xp[(i-1):(i+1), (j-1):(j+1)]
#        if(ismissing(X1[2,2]) || X1[2,2] < 2e-8)
#             ave = mean(filter(x->isreal.(x), X1))
#        end
#     end
#     ave
# end

# for i ∈ 1:size(X,1)-1
#     for j ∈ 1:size(X,2)-1
#          ave = meanX(Xp, i+1, j+1)
#          if(typeof(ave) != Bool)
#             P[i,j] = ave
#          end
#     end
# end


idx=findall(x->ismissing(x), X)

for (i, id) ∈ enumerate(idx)
    if(id[1] == 1)
        
    end 
end

     




