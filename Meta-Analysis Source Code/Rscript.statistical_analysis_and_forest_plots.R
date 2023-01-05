# Interventional studies
options(stringsAsFactors = FALSE)

library(data.table)
library(tidyverse)
library(metafor)

all <- as.data.frame(fread("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/10:13/interventional-10-13.txt", header=T, data.table=F))
positions <- c("drug","Author, Year", "Calculated TNF Patient-years, total", "Calculated Non-TNF Patient-years, total", "Total # of TNF Cancers Excluding NMSC", "Total # Placebo Cancers Excluding NMSC")
all2 <- all %>% select(positions) 
ix = which(all2$`Total # of TNF Cancers Excluding NMSC`==0 | all2$`Total # Placebo Cancers Excluding NMSC`==0)
all2$case = all2$`Total # of TNF Cancers Excluding NMSC`
all2$control = all2$`Total # Placebo Cancers Excluding NMSC`
all2$case[ix] = all2$case[ix] + 0.5
all2$control[ix] = all2$control[ix] + 0.5


## Adalimumab-Interventional
ad.int2 <- all2[all2$drug=="ADALIMUMAB", ]

## Certolizumab Interventional
cert.int2 <- all2[all2$drug=="CERTOLIZUMAB", ]

## Etanercept Interventional
etan.int2 <- all2[all2$drug=="ETANERCEPT",]

## Golimumab Interventional
goli.int2 <- all2[all2$drug=="GOLIMUMAB",]

## Infliximab Interventional
inflix.int3 <- all2[all2=="INFLIXIMAB",]

## All Five Drugs
tnfai.all5 <- all2

## Adalimumab-Interventional Random-effect
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/1:12/Adalimumab-Interventional-cancers-0.5.png", width=12, height=7, units='in',res=300)
res1 <- rma.glmm(x1i = ad.int2$case, x2i = ad.int2$control, t1i = ad.int2$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = ad.int2, slab = ad.int2$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")

forest(res1, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), 
       annotate = TRUE, addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", 
       ilab=cbind(ad.int2$`Total # of TNF Cancers Excluding NMSC`, round(ad.int2$`Calculated TNF Patient-years, total`,1), ad.int2$`Total # Placebo Cancers Excluding NMSC`, round(ad.int2$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 

op <- par(cex=.75, font=2); 
text(c(-12,-10,-7,-5), 19, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),20, c("Adalimumab", "Placebo")); 
par(op); 
text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res1$QE.LRT, digits=2, format="f")), ", df = ", .(res1$k - res1$p),", p = ", .(formatC(res1$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res1$I2, digits=1, format="f")), "%)")))
dev.off()

## Certolizumab Interventional Random-effect
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/1:12/Certolizumab-Interventional-cancers-0.5.png", width=12, height=7, units='in',res=300)
res2 <- rma.glmm(x1i = cert.int2$case, x2i = cert.int2$control, t1i = cert.int2$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = cert.int2, slab = cert.int2$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")
forest(res2, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", ilab=cbind(cert.int2$`Total # of TNF Cancers Excluding NMSC`, round(cert.int2$`Calculated TNF Patient-years, total`,1), cert.int2$`Total # Placebo Cancers Excluding NMSC`, round(cert.int2$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 

op <- par(cex=.75, font=2); 
text(c(-12,-10,-7,-5), 8, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),9, c("Certolizumab", "Placebo")); 
par(op); 
text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res2$QE.LRT, digits=2, format="f")), ", df = ", .(res2$k - res2$p),", p = ", .(formatC(res2$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res2$I2, digits=1, format="f")), "%)")))
dev.off()

## Etanercept Interventional Random-effect

png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/1:12/Etanercept-Interventional-cancers-0.5.png", width=12, height=7, units='in',res=300)
res3 <- rma.glmm(x1i = etan.int2$case, x2i = etan.int2$control, t1i = etan.int2$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = etan.int2, slab = etan.int2$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")

forest(res3, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,9), alim=c(-1.9,2), annotate = TRUE, addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", ilab=cbind(etan.int2$`Total # of TNF Cancers Excluding NMSC`, round(etan.int2$`Calculated TNF Patient-years, total`,1), etan.int2$`Total # Placebo Cancers Excluding NMSC`, round(etan.int2$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 

op <- par(cex=.75, font=2); 
text(c(-12,-10,-7,-5), 6, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),7, c("Etanercept", "Placebo")); 
par(op); 
text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res3$QE.LRT, digits=2, format="f")), ", df = ", .(res3$k - res3$p),", p = ", .(formatC(res3$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res3$I2, digits=1, format="f")), "%)")))
dev.off()

## Golimumab Interventional Random-effect
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/1:12/Golimumab-Interventional-cancers-0.5.png", width=12, height=7, units='in',res=300)
res4 <- rma.glmm(x1i = goli.int2$case, x2i = goli.int2$control, t1i = goli.int2$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = goli.int2, slab = goli.int2$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")

forest(res4, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, addfit = TRUE, addcred = FALSE, 
       xlab = "Rate Ratio (log scale)", ilab=cbind(goli.int2$`Total # of TNF Cancers Excluding NMSC`, round(goli.int2$`Calculated TNF Patient-years, total`,1), goli.int2$`Total # Placebo Cancers Excluding NMSC`, round(goli.int2$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 

op <- par(cex=.75, font=2); 
text(c(-12,-10,-7,-5), 9, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),10, c("Golimumab", "Placebo")); par(op); text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res4$QE.LRT, digits=2, format="f")), ", df = ", .(res4$k - res4$p),", p = ", .(formatC(res4$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res4$I2, digits=1, format="f")), "%)")))
dev.off()

## Infliximab Interventional Random-effect
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/1:12/Infliximab-Interventional-cancers-0.5.png", width=12, height=7, units='in',res=300)
res5 <- rma.glmm(x1i = inflix.int3$case, x2i = inflix.int3$control, t1i = inflix.int3$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = inflix.int3, slab = inflix.int3$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")

forest(res5, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", ilab=cbind(inflix.int3$`Total # of TNF Cancers Excluding NMSC`, round(inflix.int3$`Calculated TNF Patient-years, total`,1), inflix.int3$`Total # Placebo Cancers Excluding NMSC`, round(inflix.int3$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 

op <- par(cex=.75, font=2); text(c(-12,-10,-7,-5), 14, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); text(c(-11,-6),15, c("Infliximab", "Placebo")); par(op); text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res5$QE.LRT, digits=2, format="f")), ", df = ", .(res5$k - res5$p),", p = ", .(formatC(res5$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res5$I2, digits=1, format="f")), "%)")))
dev.off()


## All Five Drugs
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/1:12/All-drugs-Interventional-cancers-0.5.png", width=12, height=7, units='in',res=300)
res6 <- rma.glmm(x1i = tnfai.all5$case, x2i = tnfai.all5$control, t1i = tnfai.all5$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = tnfai.all5, slab = tnfai.all5$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")

forest(res6, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", ilab=cbind(tnfai.all5$`Total # of TNF Cancers Excluding NMSC`, round(tnfai.all5$`Calculated TNF Patient-years, total`,1), tnfai.all5$`Total # Placebo Cancers Excluding NMSC`, round(tnfai.all5$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.7, header = TRUE) 

op <- par(cex=0.7, font=2); text(c(-12,-10,-7,-5), 48, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); text(c(-11,-6),50, c("Any TNFa-i", "Placebo")); par(op); text(-16, -1, pos=4, cex=0.7, bquote(paste("RE Model (Q = ", .(formatC(res6$QE.LRT, digits=2, format="f")), ", df = ", .(res6$k - res6$p),", p = ", .(formatC(res6$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res6$I2, digits=1, format="f")), "%)")))
dev.off()


# Observational studies
options(stringsAsFactors = FALSE)

library(data.table)
library(tidyverse)
library(metafor)

all <- as.data.frame(fread("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/8:24-22/observational-8-24-22.txt", header=T, data.table=F))
positions <- c("drug","Author, Year", "Calculated TNF Patient-years, total", "Calculated Non-TNF Patient-years, total", "Total # TNF Cancers Excluding NMSC", "Total # Cancers Minus NMSC in Unexposed Patients")
all2 <- all %>% select(positions)
ix = which(all2$`Total # TNF Cancers Excluding NMSC`==0 | all2$`Total # Cancers Minus NMSC in Unexposed Patients`==0)
all2$case = all2$`Total # TNF Cancers Excluding NMSC`
all2$control = all2$`Total # Cancers Minus NMSC in Unexposed Patients`
all2$case[ix] = all2$`Total # TNF Cancers Excluding NMSC`[ix] + 0.5
all2$control[ix] = all2$`Total # Cancers Minus NMSC in Unexposed Patients`[ix] + 0.5


## Adalimumab-observational
ad.obs4 <- all2[all2$drug=="ADALIMUMAB", ]

## Etanercept Observational
etan.obs4 <- all2[all2$drug=="ETANERCEPT",]
etan.obs4 <- etan.obs4[-which(etan.obs4$`Author, Year`=="Klein, 2020"),]

## Infliximab Observational
inflix.obs4 <- all2[all2=="INFLIXIMAB",]
inflix.obs4 <- inflix.obs4[-which(inflix.obs4$`Author, Year`=="D'Haens, 2017"),]

## Certolizumab - no studies so skip

## Golimumab Observational - no studies so skip

# All drugs
tnfai.all5 <- all2
tnfai.all5 <- tnfai.all5[-which(tnfai.all5$`Author, Year`=="D'Haens, 2017"),]
tnfai.all5 <- tnfai.all5[-which(tnfai.all5$`Author, Year`=="Klein, 2020"),]

# Adalimumab-observational Random-effect
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/12:27-22/Adalimumab-Observational-cancers-0.5.png", width=12, height=7, units='in',res=300)
res1 <- rma.glmm(x1i = ad.obs4$case, x2i = ad.obs4$control, t1i = ad.obs4$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = ad.obs4, slab = ad.obs4$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")

forest(res1, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, 
       addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", 
       ilab=cbind(ad.obs4$`Total # TNF Cancers Excluding NMSC`, round(ad.obs4$`Calculated TNF Patient-years, total`,1), ad.obs4$`Total # Cancers Minus NMSC in Unexposed Patients`, round(ad.obs4$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 
op <- par(cex=.75, font=2); 
text(c(-12,-10,-7,-5), 7, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),8, c("Adalimumab", "TNFa-i Unexposed")); 
par(op); 
text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res1$QE.LRT, digits=2, format="f")), ", df = ", .(res1$k - res1$p),", p = ", .(formatC(res1$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res1$I2, digits=1, format="f")), "%)")))
dev.off()

# Etanercept-Observational Random-effect
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/12:27-22/Etanercept-Observational-cancers-0.5.png", width=12, height=7, units='in',res=300)
res2 <- rma.glmm(x1i = etan.obs4$case, x2i = etan.obs4$control, t1i = etan.obs4$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = etan.obs4, slab = etan.obs4$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")

forest(res2, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, 
       addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", 
       ilab=cbind(etan.obs4$`Total # TNF Cancers Excluding NMSC`, round(etan.obs4$`Calculated TNF Patient-years, total`,1), etan.obs4$`Total # Cancers Minus NMSC in Unexposed Patients`, round(etan.obs4$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 
op <- par(cex=.75, font=2); 
text(c(-12,-10,-7,-5), 7, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),8, c("Etanercept", "TNFa-i Unexposed")); 
par(op); 
text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res2$QE.LRT, digits=2, format="f")), ", df = ", .(res2$k - res2$p),", p = ", .(formatC(res2$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res2$I2, digits=1, format="f")), "%)")))
dev.off()

# Infliximab Observational Random-effect
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/12:27-22/Infliximab-Observational-cancers-0.5.png", width=12, height=7, units='in',res=300)
res3 <- rma.glmm(x1i = inflix.obs4$case, x2i = inflix.obs4$control, t1i = inflix.obs4$`Calculated TNF Patient-years, total`, t2i = `Calculated Non-TNF Patient-years, total`, measure = "IRR", data = inflix.obs4, slab = inflix.obs4$`Author, Year`, drop00 = TRUE, level = 95, digits = 4, verbose = F, model="CM.EL")
forest(res3, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, 
       addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)",
       ilab=cbind(inflix.obs4$`Total # TNF Cancers Excluding NMSC`, round(inflix.obs4$`Calculated TNF Patient-years, total`,1), inflix.obs4$`Total # Cancers Minus NMSC in Unexposed Patients`, round(inflix.obs4$`Calculated Non-TNF Patient-years, total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 
op <- par(cex=.75, font=2); 
text(c(-12,-10,-7,-5), 7, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),8, c("Infliximab", "TNFa-i Unexposed")); 
par(op); 
text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res3$QE.LRT, digits=2, format="f")), ", df = ", .(res3$k - res3$p),", p = ", .(formatC(res3$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res3$I2, digits=1, format="f")), "%)")))
dev.off()

# All drugs Random-effect rma.mv
png("/Users/yujiang/Documents/ibd-pca/Meta-analysis/Yu/12:27-22/All-drugs-Observational-cancers.png", width=12, height=7, units='in',res=300)
data <- escalc(measure = "IRR", x1i=`Total # TNF Cancers Excluding NMSC`,
               x2i=`Total # Cancers Minus NMSC in Unexposed Patients`,
               t1i=`Calculated TNF Patient-years, total`,
               t2i=`Calculated Non-TNF Patient-years, total`,data=tnfai.all5)
data$id <- seq(1:nrow(data))
res <- rma.mv(yi, vi, data = data, 
              slab=Author..Year, 
              test = "t",
              random=~1|Author..Year/id, method="REML")

forest(res, atransf=exp, at=log(c(0.05, 0.25, 1, 4)), xlim=c(-16,6), annotate = TRUE, 
       addfit = TRUE, addcred = FALSE, xlab = "Rate Ratio (log scale)", 
       ilab=cbind(data$`Total...TNF.Cancers.Excluding.NMSC`, round(data$`Calculated.TNF.Patient.years..total`,1), data$`Total...Cancers.Minus.NMSC.in.Unexposed.Patients`, round(data$`Calculated.Non.TNF.Patient.years..total`,1)), ilab.xpos=c(-12,-10,-7,-5), cex=.75, header = TRUE) 

op <- par(cex=0.75, font=2); 
text(c(-12,-10,-7,-5), 17, c("Cancers", "Patient-Years", "Cancers", "Patient-Years"), cex = 1, font = 1); 
text(c(-11,-6),18, c("Any TNFa-i", "TNFa-i Unexposed")); 
par(op); 
text(-16, -1, pos=4, cex=0.75, bquote(paste("RE Model (Q = ", .(formatC(res4$QE.LRT, digits=2, format="f")), ", df = ", .(res4$k - res4$p),", p = ", .(formatC(res4$QEp.LRT, digits=2, format="f")), "; ", I^2, " = ", .(formatC(res4$I2, digits=1, format="f")), "%)")))
dev.off()
