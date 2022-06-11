## API for estimating income tax in every country

Hey friends, this is just a lil wrapper that exposes the excellent Ruby gem [`income-tax`](https://github.com/rkh/income-tax) as a web API.  
I did not write any of the tax logic.

[Live demo link](https://income-tax-api.mccxiv.dev/estimate?country=DE&yearly=40000)

### Usage
Endpoint: `/estimate`

Query params:
- `country`: 2 Letter country code or English name
- `yearly`: Yearly gross salary to which tax will be subtracted

### Environment Variables
- `PORT`: defaults to 3230 when absent