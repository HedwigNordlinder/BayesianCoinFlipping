using Distributions, LinearAlgebra, Plots

coin_count = 5000
toss_count = 100

function sample_true_distribution(n)

    full_sample = zeros(n)

    for i in 1:n 
        full_sample[i] = max(0.5,min(1,rand(LogNormal(-0.35,0.1))))
    end

    return full_sample

end

biases = sample_true_distribution(coin_count)

toss_matrix = Matrix(Array{Int8}(undef,toss_count,coin_count))

for i in 1:toss_count
    for j in 1:coin_count
        toss_matrix[i,j] = rand() < biases[j] ? 1 : 0
     end
end

# We discretise our inference problem to 100 categories, 0, 0.01, 0.02 etc etc

concentration_prior = 0.5 .* ones(100) # since we have 100 categories

dirichlet_prior = rand(Dirichlet(concentration_prior))

category_occurances = zeros(100)

estimated_category = floor.(((Transpose(toss_matrix) * ones(toss_count)) ./ toss_count) .* 100) 

for i in 1:coin_count

    index = Integer(estimated_category[i])
    if index > 0 # Kinda ugly but this works
        category_occurances[index] += 1
    end
end

concentration_posterior = (concentration_prior .+ category_occurances)
dirichlet_posterior = rand(Dirichlet(concentration_posterior))
prior_plot = plot(dirichlet_prior)
posterior_plot = plot(dirichlet_posterior)
