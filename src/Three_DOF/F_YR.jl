macro F_YR()#(V, U, Ax, r, SA) # rear tire force
	code=quote
		if length(Ax) != 1
			Fyr = zeros(length(Ax),1)
			for ii in eachindex(Ax)
				Fyr[ii] = ((PD2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff))*sin(PC1*atan((((PK1*sin(2*atan(PK2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((V[ii] - lb*R[ii])/(U[ii]+EP))) + PH2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff) + PH1)) - ((PE2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff) + PE1)*(1 - PE3*(((atan((V[ii] - lb*R[ii])/(U[ii]+EP))) + PH2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff) + PH1))/((((atan((V[ii] - lb*R[ii])/(U[ii]+EP))) + PH2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff) + PH1)^2 + EP^2)^(0.5))))*((((PK1*sin(2*atan(PK2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((V[ii] - lb*R[ii])/(U[ii]+EP))) + PH2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff) + PH1)) - atan((((PK1*sin(2*atan(PK2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((V[ii] - lb*R[ii])/(U[ii]+EP))) + PH2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff) + PH1)))))) + (PV2*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)^2 + PV1*(FzR0 + (Ax[ii] - V[ii]*R[ii])*dFzx_coeff)));
			end
		else
			Fyr = Float64
			Fyr = ((PD2*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*(FzR0 + (Ax - V*R)*dFzx_coeff))*sin(PC1*atan((((PK1*sin(2*atan(PK2*(FzR0 + (Ax - V*R)*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((V - lb*R)/(U+EP))) + PH2*(FzR0 + (Ax - V*R)*dFzx_coeff) + PH1)) - ((PE2*(FzR0 + (Ax - V*R)*dFzx_coeff) + PE1)*(1 - PE3*(((atan((V - lb*R)/(U+EP))) + PH2*(FzR0 + (Ax - V*R)*dFzx_coeff) + PH1))/((((atan((V - lb*R)/(U+EP))) + PH2*(FzR0 + (Ax - V*R)*dFzx_coeff) + PH1)^2 + EP^2)^(0.5))))*((((PK1*sin(2*atan(PK2*(FzR0 + (Ax - V*R)*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((V - lb*R)/(U+EP))) + PH2*(FzR0 + (Ax - V*R)*dFzx_coeff) + PH1)) - atan((((PK1*sin(2*atan(PK2*(FzR0 + (Ax - V*R)*dFzx_coeff))))/(((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)) + ((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)))/(((PD2*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PD1*PC1*(FzR0 + (Ax - V*R)*dFzx_coeff))^2+EP^2)^(0.5))*0.001)+EP))*((atan((V - lb*R)/(U+EP))) + PH2*(FzR0 + (Ax - V*R)*dFzx_coeff) + PH1)))))) + (PV2*(FzR0 + (Ax - V*R)*dFzx_coeff)^2 + PV1*(FzR0 + (Ax - V*R)*dFzx_coeff)));
		end
		Fyr
	end
	return esc(code)
end
