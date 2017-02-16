# Three DOF Vehicle Model
include("F_YR.jl")
include("F_YF.jl")
include("parameters.jl")

# other functions to export
include("FZ_RL.jl")
include("FZ_RR.jl")
include("Ax_max.jl")
include("Ax_min.jl")

"""
dx = ThreeDOFv1(mdl,n,R,x,u,params)
--------------------------------------------------------------------------------------\n
Author: Huckleberry Febbo, Graduate Student, University of Michigan
Date Create: 10/20/2017, Last Modified: 2/1/2017 \n
--------------------------------------------------------------------------------------\n
# this vehicle model is controlled using steering angle and speed
"""
function ThreeDOFv1{T<:Any}(mdl::JuMP.Model,n,R,x::Array{T,2},u::Array{T,2},params)
  if n.integrationMethod==:tm; L=size(x)[1]; else; L=size(x)[1]-1; end
  dx = Array(Any,L,n.numStates)
  v = x[:,3]; r = x[:,4]; psi = x[:,5];

  # parameters
  ax = zeros(length(psi)); sa = u[:,1];
  pa=params[1]; UX=params[2];
  ux=getvalue(UX)*ones(L,1);  # assume UX is a constant
  @unpack_Vpara pa            # vehicle parameters

  # nonlinear tire model TODO make sure this works for multiple interval
  FYF=@NLexpression(mdl, [i = 1:L], (PD2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))*sin(PC1*atan((((PK1*sin(2*atan(PK2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))^2 + EP^2)^(0.5))*0.001)+EP))*((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - ((PE2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PE1)*(1 - PE3)*(((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1))/((((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)^2 + EP^2)^(0.5)))*((((PK1*sin(2*atan(PK2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))^2 + EP^2)^(0.5))*0.001)+EP))*((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - atan((((PK1*sin(2*atan(PK2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))^2 + EP^2)^(0.5))*0.001)+EP))*((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)))))) + (PV2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PV1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)));
  FYR=@NLexpression(mdl, [i = 1:L], (PD2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))*sin(PC1*atan((((PK1*sin(2*atan(PK2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - ((PE2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PE1)*(1 - PE3*(((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1))/((((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)^2 + EP^2)^(0.5))))*((((PK1*sin(2*atan(PK2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - atan((((PK1*sin(2*atan(PK2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)))))) + (PV2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PV1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)));

  # vertical tire load
  FZ_rl_con=@NLconstraint(mdl, [i=1:L], 0 <=  0.5*(FzR0 + KZX*(ax[i] - v[i]*r[i])) - KZYR*((FYF[i] + FYR[i])/m) - Fz_min)
  newConstraint(R,FZ_rl_con,:FZ_rl_con); #TODO consider appending for multiple interval
  FZ_rr_con=@NLconstraint(mdl, [i=1:L], 0 <=  0.5*(FzR0 + KZX*(ax[i] - v[i]*r[i])) + KZYR*((FYF[i] + FYR[i])/m) - Fz_min)
  newConstraint(R,FZ_rr_con,:FZ_rr_con);

  # linear tire and for now this also constrains the nonlinear tire model
  Fyf_con=@NLconstraint(mdl, [i=1:L], Fyf_min <=  (atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i])*Caf <= Fyf_max);
  newConstraint(R,Fyf_con,:Fyf_con);
  Fyr_con=@NLconstraint(mdl, [i=1:L], Fyf_min <=   atan((v[i] - lb*r[i])/(ux[i]+EP))*Car <= Fyf_max);
  newConstraint(R,Fyr_con,:Fyr_con);

  dx[:,1] = @NLexpression(mdl, [i=1:L], ux[i]*cos(psi[i]) - (v[i] + la*r[i])*sin(psi[i]));    # X position
  dx[:,2] = @NLexpression(mdl, [i=1:L], ux[i]*sin(psi[i]) + (v[i] + la*r[i])*cos(psi[i]));    # Y position
  dx[:,3] = @NLexpression(mdl, [i=1:L], (FYF[i] + FYR[i])/m - r[i]*ux[i]);                    # Lateral Speed
  dx[:,4] = @NLexpression(mdl, [i=1:L], (la*FYF[i]-lb*FYR[i])/Izz);                           # Yaw Rate
  dx[:,5] = @NLexpression(mdl, [i=1:L], r[i]);                                                # Yaw Angle
  return dx
end

function ThreeDOFv1(pa::Vpara,
                    x0::Vector,
                     t::Vector,
                    SA::Vector,
                     U::Vector,
                    t0::Float64,
                    tf::Float64)
    @unpack_Vpara pa
    # create splines
    sp_SA=Linear_Spline(t,SA);
    sp_U=Linear_Spline(t,U);

    f = (t,x,dx) -> begin
    # states
    V   = x[3];  # 3. Lateral Speed
    R   = x[4];  # 4. Yaw Rate
    PSI = x[5];  # 5. Yaw angle

    # controls
    SA  = sp_SA[t]; # Steering Angle
    U  = sp_U[t];   # Longitudinal Speed

    # set variables for tire equations
    Ax = 0;

    # diff eqs.
    dx[1]   = U*cos(PSI) - (V + la*R)*sin(PSI);    # X position
    dx[2] 	= U*sin(PSI) + (V + la*R)*cos(PSI);    # Y position
    dx[3]   = (@F_YF() + @F_YR())/m - R*U;         # Lateral Speed
    dx[4]  	= (la*@F_YF()-lb*@F_YR())/Izz;         # Yaw Rate
    dx[5]  	= R;                                   # Yaw Angle
  end
  tspan = (t0,tf)
  prob = ODEProblem(f, x0,tspan)
  DifferentialEquations.solve(prob)
end

"""
dx = ThreeDOFv2(mdl,n,x,u,params)
--------------------------------------------------------------------------------------\n
Author: Huckleberry Febbo, Graduate Student, University of Michigan
Date Create: 10/20/2017, Last Modified: 2/6/2017 \n
--------------------------------------------------------------------------------------\n
# this vehicle model is controlled using steering rate and longitudinal jerk

"""
function ThreeDOFv2{T<:Any}(mdl::JuMP.Model,n,R,x::Array{T,2},u::Array{T,2},params)
  if n.integrationMethod==:tm; L=size(x)[1]; else; L=size(x)[1]-1; end
  dx = Array(Any,L,n.numStates)
  # states
  v = x[:,3]; r = x[:,4]; psi = x[:,5]; sa = x[:,6]; ux = x[:,7]; ax = x[:,8];

  # controls
  sr = u[:,1]; jx = u[:,2];

  # parameters
  pa=params[1];
  @unpack_Vpara pa  # vehicle parameters

  # nonlinear tire model TODO make sure this works for multiple interval #TODO consider embeding -> will make it look nasty but may speed up
  FYF=@NLexpression(mdl, [i = 1:L], (PD2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))*sin(PC1*atan((((PK1*sin(2*atan(PK2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))^2 + EP^2)^(0.5))*0.001)+EP))*((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - ((PE2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PE1)*(1 - PE3)*(((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1))/((((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)^2 + EP^2)^(0.5)))*((((PK1*sin(2*atan(PK2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))^2 + EP^2)^(0.5))*0.001)+EP))*((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - atan((((PK1*sin(2*atan(PK2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff))^2 + EP^2)^(0.5))*0.001)+EP))*((atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i]) + PH2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)))))) + (PV2*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PV1*(FzF0 - (ax[i] - v[i]*r[i])*dFzx_coeff)));
  FYR=@NLexpression(mdl, [i = 1:L], (PD2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))*sin(PC1*atan((((PK1*sin(2*atan(PK2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - ((PE2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PE1)*(1 - PE3*(((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1))/((((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)^2 + EP^2)^(0.5))))*((((PK1*sin(2*atan(PK2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)) - atan((((PK1*sin(2*atan(PK2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((v[i] - lb*r[i])/(ux[i]+EP))) + PH2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff) + PH1)))))) + (PV2*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)^2 + PV1*(FzR0 + (ax[i] - v[i]*r[i])*dFzx_coeff)));

  # vertical tire load
  FZ_rl_con=@NLconstraint(mdl, [i=1:L], 0 <=  0.5*(FzR0 + KZX*(ax[i] - v[i]*r[i])) - KZYR*((FYF[i] + FYR[i])/m) - Fz_min)
  newConstraint(R,FZ_rl_con,:FZ_rl_con);
  FZ_rr_con=@NLconstraint(mdl, [i=1:L], 0 <=  0.5*(FzR0 + KZX*(ax[i] - v[i]*r[i])) + KZYR*((FYF[i] + FYR[i])/m) - Fz_min)
  newConstraint(R,FZ_rr_con,:FZ_rr_con);

  # linear tire and for now this also constrains the nonlinear tire model
  Fyf_con=@NLconstraint(mdl, [i=1:L], Fyf_min <=  (atan((v[i] + la*r[i])/(ux[i]+EP)) - sa[i])*Caf <= Fyf_max)
  newConstraint(R,Fyf_con,:Fyf_con);
  Fyr_con=@NLconstraint(mdl, [i=1:L], Fyf_min <=   atan((v[i] - lb*r[i])/(ux[i]+EP))*Car <= Fyf_max)
  newConstraint(R,Fyr_con,:Fyr_con);

  # nonlinear accleleration bounds
  min_ax_con=@NLconstraint(mdl, [i=1:L], 0  <=  ax[i] - (AXC[5]*ux[i]^3 + AXC[6]*ux[i]^2 + AXC[7]*ux[i] + AXC[8]) )
  newConstraint(R,min_ax_con,:min_ax_con); #TODO consider adding back L+1 for ps methods
  max_ax_con=@NLconstraint(mdl, [i=1:L], ax[i] - (AXC[1]*ux[i]^3 + AXC[2]*ux[i]^2 + AXC[3]*ux[i] + AXC[4]) <= 0 )
  newConstraint(R,max_ax_con,:max_ax_con);

  dx[:,1] = @NLexpression(mdl, [i=1:L], ux[i]*cos(psi[i]) - (v[i] + la*r[i])*sin(psi[i]));    # X position
  dx[:,2] = @NLexpression(mdl, [i=1:L], ux[i]*sin(psi[i]) + (v[i] + la*r[i])*cos(psi[i]));    # Y position
  dx[:,3] = @NLexpression(mdl, [i=1:L], (FYF[i] + FYR[i])/m - r[i]*ux[i]);                    # Lateral Speed
  dx[:,4] = @NLexpression(mdl, [i=1:L], (la*FYF[i]-lb*FYR[i])/Izz);                           # Yaw Rate
  dx[:,5] = @NLexpression(mdl, [i=1:L], r[i]);                                                # Yaw Angle
  dx[:,6] = @NLexpression(mdl, [i=1:L], sr[i]);                                               # Steering Angle
  dx[:,7] = @NLexpression(mdl, [i=1:L], ax[i]);                                               # Longitudinal Speed
  dx[:,8] = @NLexpression(mdl, [i=1:L], jx[i]);                                               # Longitudinal Acceleration
  return dx
end

function ThreeDOFv2(pa::Vpara,
                   x0::Vector,
                   t::Vector,
                   SR::Vector,
                   Jx::Vector,
                   t0::Float64,
                   tf::Float64)
    @unpack_Vpara pa

    # create splines
    sp_SR=Linear_Spline(t,SR);
    sp_Jx=Linear_Spline(t,Jx);

    f = (t,x,dx) -> begin

    # states
    V   = x[3];  # 3. Lateral Speed
    R   = x[4];  # 4. Yaw Rate
    PSI = x[5];  # 5. Yaw angle
    SA  = x[6];  # 6. Steering Angle
    U   = x[7];  # 7. Longitudinal Speed
    Ax  = x[8];  # 8. Longitudinal Acceleration

    # controls
    SR  = sp_SR[t];
    Jx  = sp_Jx[t];

    # diff eqs.
    dx[1]   = U*cos(PSI) - (V + la*R)*sin(PSI);    # X position
    dx[2] 	= U*sin(PSI) + (V + la*R)*cos(PSI);    # Y position
    dx[3]   = (@F_YF() + @F_YR())/m - R*U;         # Lateral Speed
    dx[4]  	= (la*@F_YF()-lb*@F_YR())/Izz;         # Yaw Rate
    dx[5]  	= R;                                   # Yaw Angle
    dx[6]   = SR;                                  # Steering Angle
    dx[7]  	= Ax;                                  # Longitudinal Speed
    dx[8]  	= Jx;                                  # Longitudinal Acceleration
  end
  tspan = (t0,tf)
  prob = ODEProblem(f, x0,tspan)
  DifferentialEquations.solve(prob)
end
