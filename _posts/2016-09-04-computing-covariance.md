---
layout: post
title: Computing covariance
comments: true
---

For a given m x n matrix $X = {X_{ij}}$, where each row is a sample, each column is a **zero-mean** feature, the normal way of computing covariance matrix is

$$ \Sigma = (1/m) * X^T \times X $$

This can be easily understood - $\Sigma_{ij}$ is the covariance between i-th and j-th feature of the dataset. The computation reflects that - $\Sigma_{ij}$ is computed by $(1/m) * <X_i, X_j>$, where $<X_i, X_j>$ is the inner product between column $X_i$ and column $X_j$. Since all features (columns) are zero-mean, this is exactly the definition of covariance between two random variables.

To my suprise, the other way of estimating the covariance is:

$$ \Sigma = \sum_{i=1}^m { {X^{(i)}}^T \times X^{(i)} }  $$



<script src="https://gist.github.com/kflu/c8dbb4a365302386109724faa2c15cbe.js"></script>
