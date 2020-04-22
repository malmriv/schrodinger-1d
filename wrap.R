# Author: Manuel Almagro.
# Description: R script to act as wrap for the Fortran program I wrote to solve
# the 1D Schrodinger equation. The program sets certain parameters, executes the
# Fortran program and the plots the results.

#Set parameters
N = 4000
lambda = 1.1
s = 0.0001
h = 0.0001
cycles = 200
iterations = 3000

#Save into a Fortran readable file as specfied:
#.txt, one row, decimal marked by dot, separation marked by tabs
write.table(data.frame(N,lambda,s,h,cycles,iterations),"./config.txt",sep="\t",dec=".",col.names=FALSE,row.names=FALSE,quote=FALSE)

#Create necessary directories
dir.create("./results/")
dir.create("./results/frames")

#Execute the program
system("./schrodinger")

#Read data
wave = read.table("./results/wavefunction.txt")

#Define x-axis values variables needed:
xdomain=seq(0,h*N,len=N)

for(i in 1:iterations) {
  #Generate a frame every X iterations
  if(i%%5 == 0) {
  y = wave[((i-1)*N+1):(i*N),1]
  png(paste("./results/frames/",i,".png",sep=""),width=600,height=400)
  par(cex.axis=1.1,cex.main=1.4)
  plot(xdomain,y,type="l",ylim=c(0,2),col=rgb(0.10,0.21,0.37,0.5),xlab="position",ylab="wave function squared",main="1D Schrödinger equation.")
  polygon(c(0,0.4*h*N,0.4*h*N,0.6*h*N,0.6*h*N,h*N),c(0,0,1,1,0,0),col=rgb(0.77,0.84,0.94,0.5),border="black")
  polygon(c(0,xdomain,0),c(0,y,0),col=rgb(0.10,0.21,0.37,0.5))
  legend(0.85*N*h,1.95,c("φ²","potential"),col=c(rgb(0.10,0.21,0.37,0.5),rgb(0.77,0.84,0.94,0.5)),pch=19,cex=1)
  mtext(paste("potential height (image only orientative): ",round(2*pi/cycles*lambda,5),sep=""),side=3,line=0.4)
  dev.off()
  }
  #Check for norm conservation with rough numerical integration
  integral = sum(wave[((i-1)*N+1):(i*N),1]*h)
  write.table(integral,"./results/norm.txt",append=TRUE,row.names=FALSE,col.names=FALSE,quote=FALSE)
}

#Plot norm vs. iterations
norm = read.table("./results/norm.txt")
png("./results/norm.png",width=600,height=400)
plot(c(1:length(norm[,1])),abs(mean(norm[,1])-norm[,1]),type="l",lwd=2,col="red",main="Norm conservation (abs. deviation from mean)",xlab="iteration (adim.)",ylab="norm (adim.)")
mtext(paste("Mean norm:",round(mean(norm[,1]),9)),side=3,line=0.4)
dev.off()

#Delete residual files
system("rm ./config.txt")
system("rm ./results/norm.txt")

