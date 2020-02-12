#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sklearn.base import BaseEstimator, TransformerMixin

import numpy as np
import scipy.optimize
import cvxopt
import cvxopt.solvers

class LinStrat(BaseEstimator, TransformerMixin):
    
    def __init__(self, n_strata=3, max_iter=100, n_init=50, tol=1e-9, verbose=None):
        self.K = n_strata
        self.verbose = verbose
        self.max_iter = max_iter
        self.n_init = n_init
        self.tol = tol
        
    def fit(self, X, y=None):
        self.N, self.M = X.shape
        self.S, self.w, self.c = self.optimize(X)
        cost_best = self.__cost__(X, self.S, self.w, self.c)
        for i in range(self.n_init - 1):
            if cost_best == 0:
                break
            S, w, c = self.optimize(X)
            cost = self.__cost__(X, S, w, c)
            if self.verbose:
                print "Replication:", i, "final cost: ", cost 
            if cost < cost_best:
                cost_best = cost
                self.S, self.w, self.c = S, w, c
        if self.verbose:
            print "Final weigths", self.w, "cost", cost_best
    
    def predict(self, X):
        r = np.dot(X ,self.w)
        tt = np.abs(np.tile(self.c, (self.N, 1)) - np.tile(r, (self.K, 1)).T)
        return np.argmin(tt, axis=1)
#         return np.argmax(self.S, axis=1)
    
    def optimize(self, X):
        
        # Initilize w, c
        w = self.init_weights()
        c = self.init_centers(X, w)
        S = self.find_s_given_w_and_c(X, w, c)
        w, c = self.find_w_and_c_given_s(X, S)
        cost_prev = self.__cost__(X, S, w, c)
        # Optimize
        for i in range(self.max_iter):
            # Find w, c
            w, c = self.find_w_and_c_given_s(X, S)
            # find S
            S = self.find_s_given_w_and_c(X, w, c)
            # Check conergence
            cost_next = self.__cost__(X, S, w, c)
            if abs(cost_next - cost_prev) < self.tol:
                if self.verbose:
                    print "Linstrat converged with ", i, "iterations"
                break
                
            if self.verbose:
                print "Iteration:", i, "cost: ", cost_next
            cost_prev = cost_next
            
        return S, w, c
    
    def init_weights(self):
        w = np.random.rand(1, self.M - 1)[0]
        return np.sort(np.append(w, 1.)) - np.sort(np.append(0., w))
    
    def init_centers(self, X, w):
        r = np.dot(X ,w)
        np.random.shuffle(r)
        return np.sort(r[:self.K])
        # return np.sort(min(r) + (max(r)- min(r)) * np.random.rand(1, self.K))[0]
    
    def find_s_given_w_and_c(self, X, w, c):
        r = np.dot(X, w)
        tt = np.abs(np.tile(c, (self.N, 1)) - np.tile(r, (self.K, 1)).T)
        index = np.argmin(tt, axis=1)
        S = np.zeros((self.N, self.K))
        for i, idx in enumerate(index):
            S[i, idx] =  1
        return S
    
    def find_w_and_c_given_s(self, X, S):
        # Solve QP problem for w
        part1 = np.linalg.inv(np.matmul(S.T, S))
        part2 = np.matmul(S.T, X)
        Y = X - np.matmul(S, np.matmul(part1, part2))
        
        # Y = X - np.tile(np.dot(S, c), (self.M, 1)).T;
        P = cvxopt.matrix(np.matmul(Y.T, Y))
        q = cvxopt.matrix(np.zeros((self.M, 1)))
        G = cvxopt.matrix(-np.eye(self.M))
        h = cvxopt.matrix(np.zeros((self.M, 1)))
        A = cvxopt.matrix(np.ones((1, self.M)))
        b = cvxopt.matrix(np.ones((1, 1)))
        
        cvxopt.solvers.options['show_progress'] = False
        sol = cvxopt.solvers.qp(cvxopt.matrix(P), cvxopt.matrix(q), cvxopt.matrix(G), cvxopt.matrix(h), cvxopt.matrix(A), cvxopt.matrix(b))
        w = np.array(sol['x']).T[0]
        
        # Find c 
        c = np.dot(np.matmul(part1, part2), w)
        # c = np.matmul(np.matmul(w, data.T), S)/ np.sum(S, axis=0)
        return w, c
        
            
    def __cost__(self, X, S, w, c):
        delta = X.dot(w) - S.dot(c)
        cost = 0.5*delta.dot(delta)
        return cost
