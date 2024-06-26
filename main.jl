using Distributions, LinearAlgebra

coin_count = 50
toss_count = 10

function sample_true_distribution(n)

    full_sample = zeros(n)

    for i in 1:n 
        full_sample[i] = max(0.5,min(1,rand(LogNormal(-0.35,0.1))))
    end

    return full_sample

end

biases = sample_true_distribution(50)

toss_matrix = Array{Int8}(undef,toss_count,coin_count)

for i in 1:toss_count
    for j in 1:coin_count
        toss_matrix[i,j] = rand() < biases[j] ? 1 : 0
     end
end
