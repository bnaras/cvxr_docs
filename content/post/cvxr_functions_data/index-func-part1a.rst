   * - Function
     - Meaning
     - Domain
     - Sign
     - Curvature |_|
     - Monotonicity

   * - :ref:`geo_mean(x) <geo_mean>`

       :ref:`geo_mean(x, p) <geo_mean>`

       :math:`p \in \mathbf{R}^n_{+}`

       :math:`p \neq 0`
     - :math:`x_1^{1/n} \cdots x_n^{1/n}`

       :math:`\left(x_1^{p_1} \cdots x_n^{p_n}\right)^{\frac{1}{\mathbf{1}^T p}}`
     - :math:`x \in \mathbf{R}^n_{+}`
     - |positive| positive
     - |concave| concave
     - |incr| incr.

   * - harmonic_mean(x)
     - :math:`\frac{n}{\frac{1}{x_1} + \cdots + \frac{1}{x_n}}`
     - :math:`x \in \mathbf{R}^n_{+}`
     - |positive| positive
     - |concave| concave
     - |incr| incr.

   * - lambda_max(X)
     - :math:`\lambda_{\max}(X)`
     - :math:`X \in \mathbf{S}^n`
     - |unknown| unknown
     - |convex| convex
     - None

   * - lambda_min(X)
     - :math:`\lambda_{\min}(X)`
     - :math:`X \in \mathbf{S}^n`
     - |unknown| unknown
     - |concave| concave
     - None

   * - lambda_sum_largest(X, |_| k)

       :math:`k = 1,\ldots, n`
     - :math:`\text{sum of $k$ largest}\\ \text{eigenvalues of $X$}`
     - :math:`X \in\mathbf{S}^{n}`
     - |unknown| unknown
     - |convex| convex
     - None

   * - lambda_sum_smallest(X, |_| k)

       :math:`k = 1,\ldots, n`
     - :math:`\text{sum of $k$ smallest}\\ \text{eigenvalues of $X$}`
     - :math:`X \in\mathbf{S}^{n}`
     - |unknown| unknown
     - |concave| concave
     - None

   * - log_det(X)
     - :math:`\log \left(\det (X)\right)`
     - :math:`X \in \mathbf{S}^n_+`
     - |unknown| unknown
     - |concave| concave
     - None

   * - log_sum_exp(X)
     - :math:`\log \left(\sum_{ij}e^{X_{ij}}\right)`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - |unknown| unknown
     - |convex| convex
     - |incr| incr.

   * - matrix_frac(x, P)
     - :math:`x^T P^{-1} x`
     - :math:`x \in \mathbf{R}^n`

       :math:`P \in\mathbf{S}^n_{++}`
     - |positive| positive
     - |convex| convex
     - None

   * - max_entries(X)
     - :math:`\max_{ij}\left\{ X_{ij}\right\}`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - same as X
     - |convex| convex
     - |incr| incr.

   * - min_entries(X)
     - :math:`\min_{ij}\left\{ X_{ij}\right\}`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - same as X
     - |concave| concave
     - |incr| incr.

   * - mixed_norm(X, p, q)
     - :math:`\left(\sum_k\left(\sum_l\lvert x_{k,l}\rvert^p\right)^{q/p}\right)^{1/q}`
     - :math:`X \in\mathbf{R}^{n \times n}`
     - |positive| positive
     - |convex| convex
     - None

   * - norm(x)

       norm(x, 2)
     - :math:`\sqrt{\sum_{i}x_{i}^2 }`
     - :math:`X \in\mathbf{R}^{n}`
     - |positive| positive
     - |convex| convex
     - |incr| for :math:`x_{i} \geq 0`

       |decr| for :math:`x_{i} \leq 0`

   * - norm(X, "fro")
     - :math:`\sqrt{\sum_{ij}X_{ij}^2 }`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - |incr| for :math:`X_{ij} \geq 0`

       |decr| for :math:`X_{ij} \leq 0`

   * - norm(X, 1)
     - :math:`\sum_{ij}\lvert X_{ij} \rvert`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - |incr| for :math:`X_{ij} \geq 0`

       |decr| for :math:`X_{ij} \leq 0`

   * - norm(X, "inf")
     - :math:`\max_{ij} \{\lvert X_{ij} \rvert\}`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - |incr| for :math:`X_{ij} \geq 0`

       |decr| for :math:`X_{ij} \leq 0`

   * - norm(X, "nuc")
     - :math:`\mathrm{tr}\left(\left(X^T X\right)^{1/2}\right)`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - None

   * - norm(X)

       norm(X, 2)
     - :math:`\sqrt{\lambda_{\max}\left(X^T X\right)}`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - None

   * - :ref:`pnorm(X, p) <pnorm>`

       :math:`p \geq 1`

       or ``p = 'inf'``
     - :math:`\|X\|_p = \left(\sum_{ij} |X_{ij}|^p \right)^{1/p}`
     - :math:`X \in \mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - |incr| for :math:`X_{ij} \geq 0`

       |decr| for :math:`X_{ij} \leq 0`

   * - :ref:`pnorm(X, p) <pnorm>`

       :math:`p < 1`, :math:`p \neq 0`
     - :math:`\|X\|_p = \left(\sum_{ij} X_{ij}^p \right)^{1/p}`
     - :math:`X \in \mathbf{R}^{m \times n}_+`
     - |positive| positive
     - |concave| concave
     - |incr| incr.


   * - quad_form(x, P)

       constant :math:`P \in \mathbf{S}^n_+`
     - :math:`x^T P x`
     - :math:`x \in \mathbf{R}^n`


     - |positive| positive
     - |convex| convex
     - |incr| for :math:`x_i \geq 0`

       |decr| for :math:`x_i \leq 0`

   * - quad_form(x, P)

       constant :math:`P \in \mathbf{S}^n_-`
     - :math:`x^T P x`
     - :math:`x \in \mathbf{R}^n`
     - |negative| negative
     - |concave| concave
     - |decr| for :math:`x_i \geq 0`

       |incr| for :math:`x_i \leq 0`

   * - quad_form(c, X)

       constant :math:`c \in \mathbf{R}^n`
     - :math:`c^T X c`
     - :math:`X \in\mathbf{R}^{n \times n}`
     - depends |_| on |_| c, |_| X
     - |affine| affine
     - depends |_| on |_| c

   * - quad_over_lin(X, y)
     - :math:`\left(\sum_{ij}X_{ij}^2\right)/y`
     - :math:`x \in \mathbf{R}^n`

       :math:`y > 0`
     - |positive| positive
     - |convex| convex
     - |incr| for :math:`X_{ij} \geq 0`

       |decr| for :math:`X_{ij} \leq 0`

       |decr| decr. in :math:`y`

   * - sum_entries(X)
     - :math:`\sum_{ij}X_{ij}`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - same as X
     - |affine| affine
     - |incr| incr.

   * - sum_largest(X, k)

       :math:`k = 1,2,\ldots`
     - :math:`\text{sum of } k\text{ largest }X_{ij}`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - same as X
     - |convex| convex
     - |incr| incr.

   * - sum_smallest(X, k)

       :math:`k = 1,2,\ldots`
     - :math:`\text{sum of } k\text{ smallest }X_{ij}`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - same as X
     - |concave| concave
     - |incr| incr.

   * - sum_squares(X)
     - :math:`\sum_{ij}X_{ij}^2`
     - :math:`X \in\mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - |incr| for :math:`X_{ij} \geq 0`

       |decr| for :math:`X_{ij} \leq 0`

   * - trace(X)
     - :math:`\mathrm{tr}\left(X \right)`
     - :math:`X \in\mathbf{R}^{n \times n}`
     - same as X
     - |affine| affine
     - |incr| incr.

   * - tv(x)
     - :math:`\sum_{i}|x_{i+1} - x_i|`
     - :math:`x \in \mathbf{R}^n`
     - |positive| positive
     - |convex| convex
     - None

   * - tv(X)
     - :math:`\sum_{ij}\left\| \left[\begin{matrix} X_{i+1,j} - X_{ij} \\ X_{i,j+1} -X_{ij} \end{matrix}\right] \right\|_2`
     - :math:`X \in \mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - None

   * - tv(X1,...,Xk)
     - :math:`\sum_{ij}\left\| \left[\begin{matrix} X_{i+1,j}^{(1)} - X_{ij}^{(1)} \\ X_{i,j+1}^{(1)} -X_{ij}^{(1)} \\ \vdots \\ X_{i+1,j}^{(k)} - X_{ij}^{(k)} \\ X_{i,j+1}^{(k)} -X_{ij}^{(k)}  \end{matrix}\right] \right\|_2`
     - :math:`X^{(i)} \in\mathbf{R}^{m \times n}`
     - |positive| positive
     - |convex| convex
     - None
       
