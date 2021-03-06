# shiny-app copulas

library(shiny)
library(spcopula)

# Define server logic

checkFrank <- function(param) {
  if(param==0)
    return(indepCopula(2))
  else
    return(frankCopula(param))
}

rotateBB1 <- function(input) {
  switch(input$rot,
         none = BB1Copula(c(input$param1BB1pos, input$param2BB1pos)),
         r90 = r90BB1Copula(c(input$param1BB1neg, input$param2BB1neg)),
         sur = surBB1Copula(c(input$param1BB1pos, input$param2BB1pos)),
         r270 = r270BB1Copula(c(input$param1BB1neg, input$param2BB1neg)))
}

rotateBB6 <- function(input) {
  switch(input$rot,
         none = BB6Copula(c(input$param1BB6pos, input$param2BB6pos)),
         r90 = r90BB6Copula(c(input$param1BB6neg, input$param2BB6neg)),
         sur = surBB6Copula(c(input$param1BB6pos, input$param2BB6pos)),
         r270 = r270BB6Copula(c(input$param1BB6neg, input$param2BB6neg)))
}

rotateBB7 <- function(input) {
  switch(input$rot,
         none = BB7Copula(c(input$param1BB7pos, input$param2BB7pos)),
         r90 = r90BB7Copula(c(input$param1BB7neg, input$param2BB7neg)),
         sur = surBB7Copula(c(input$param1BB7pos, input$param2BB7pos)),
         r270 = r270BB7Copula(c(input$param1BB7neg, input$param2BB7neg)))
}

rotateBB8 <- function(input) {
  switch(input$rot,
         none = BB8Copula(c(input$param1BB8pos, input$param2BB8pos)),
         r90 = r90BB8Copula(c(input$param1BB8neg, input$param2BB8neg)),
         sur = surBB8Copula(c(input$param1BB8pos, input$param2BB8pos)),
         r270 = r270BB8Copula(c(input$param1BB8neg, input$param2BB8neg)))
}

rotateClayton <- function(input) {
  switch(input$rot,
         none = claytonCopula(input$paramClaytonNone),
         r90 = r90ClaytonCopula(input$paramClaytonNeg),
         sur = surClaytonCopula(input$paramClaytonSur),
         r270 = r270ClaytonCopula(input$paramClaytonNeg))
}

rotateGumbel <- function(input) {
  switch(input$rot,
         none = gumbelCopula(input$paramGumbelPos),
         r90 = r90GumbelCopula(input$paramGumbelNeg),
         sur = surGumbelCopula(input$paramGumbelPos),
         r270 = r270GumbelCopula(input$paramGumbelNeg))
}

rotateJoe <- function(input) {
  switch(input$rot,
         none = joeBiCopula(input$paramJoePos),
         r90 = r90JoeBiCopula(input$paramJoeNeg),
         sur = surJoeBiCopula(input$paramJoePos),
         r270 = r270JoeBiCopula(input$paramJoeNeg))
}

rotateTawnT1 <- function(input) {
  switch(input$rot,
         none = tawnT1Copula(c(input$param1TawnPos, input$param2TawnPos)),
         r90 = r90TawnT1Copula(c(input$param1TawnNeg, input$param2TawnNeg)),
         sur = surTawnT1Copula(c(input$param1TawnPos, input$param2TawnPos)),
         r270 = r270TawnT1Copula(c(input$param1TawnNeg, input$param2TawnNeg)))
}

rotateTawnT2 <- function(input) {
  switch(input$rot,
         none = tawnT2Copula(c(input$param1TawnPos, input$param2TawnPos)),
         r90 = r90TawnT2Copula(c(input$param1TawnNeg, input$param2TawnNeg)),
         sur = surTawnT2Copula(c(input$param1TawnPos, input$param2TawnPos)),
         r270 = r270TawnT2Copula(c(input$param1TawnNeg, input$param2TawnNeg)))
}

loadSpCop <- function() {
  data(spCopDemo)
  
  calcKTauPol <- fitCorFun(bins, degree=3)
  
  spCopula(components=list(normalCopula(0), tCopula(0, dispstr = "un"),
                           frankCopula(1), normalCopula(0), claytonCopula(0),
                           claytonCopula(0), claytonCopula(0), claytonCopula(0),
                           claytonCopula(0), indepCopula()),
                    distances=bins$meanDists,
                    spDepFun=calcKTauPol, unit="m")
}

perspGauss <- function (copula, ...) {
  n <- 51
  xis <- yis <- seq(-3, 3, len = n)
  uis <- vis <- pnorm(xis)
  grids <- as.matrix(expand.grid(uis, vis, KEEP.OUT.ATTRS = FALSE))
  zmat <- matrix(dCopula(grids, copula)*dnorm(qnorm(grids[,1]))*dnorm(qnorm(grids[,2])), n, n)
  persp(xis, yis, zmat, theta = -30, phi = 30, expand = 0.618,  ...)
}

contourGauss <- function (copula, ...) {
  n <- 51
  xis <- yis <- seq(-3, 3, len = n)
  uis <- vis <- pnorm(xis)
  grids <- as.matrix(expand.grid(uis, vis, KEEP.OUT.ATTRS = FALSE))
  zmat <- matrix(dCopula(grids, copula)*dnorm(qnorm(grids[,1]))*dnorm(qnorm(grids[,2])), n, n)
  contour(xis, yis, zmat,asp=1, ...)
}

spatialPersp <- function (copula, h, ...) {
  n <- 51
  eps <- 0
  xis <- yis <- seq(0+eps, 1 - eps, len = n)
  grids <- as.matrix(expand.grid(xis, yis, KEEP.OUT.ATTRS = FALSE))
  zmat <- matrix(dCopula(grids, copula, h=h), n, n)
  persp(xis, yis, zmat, theta = -30, phi = 30, expand = 0.618, ...)
}

spatialPerspGauss <- function (copula, h, ...) {
  n <- 51
  xis <- yis <- seq(-3, 3, len = n)
  uis <- vis <- pnorm(xis)
  grids <- as.matrix(expand.grid(uis, vis, KEEP.OUT.ATTRS = FALSE))
  zmat <- matrix(dCopula(grids, copula, h=h)*dnorm(qnorm(grids[,1]))*dnorm(qnorm(grids[,2])), n, n)
  par(mfrow=c(1,2))
  persp(xis, yis, zmat, theta = -30, phi = 30, expand = 0.618,  ...)
  contour(xis, yis, zmat,asp=1)
}

shinyServer(function(input, output) {
  
  # generate conditional slider
  output$paramA <- renderUI({
    paramB <- input$b
    limA <- spcopula:::limA(paramB)
    
    # check whether slider "a" has once been acivated
    if(is.null(input$a))
      a <- 0
    else 
      a <- input$a
    
    sliderInput("a", "parameter a:",  
                min = limA, max = 1, value = max(limA, a), step=0.01)
  })
  
  paramA <- reactive({
    if(is.null(input$a))
      return(0)
    else
      return(input$a)
  })
                     
  paramB <- reactive({
   if(is.null(input$b))
     return(0)
   else
     return(input$b)
  })
  
  cop <- reactive(switch(input$family,
                         asCopula = asCopula(c(paramA(),paramB())),
                         BB1Copula = rotateBB1(input),
                         BB6Copula = rotateBB6(input),
                         BB7Copula = rotateBB7(input),
                         BB8Copula = rotateBB8(input),
                         claytonCopula = rotateClayton(input),
                         cqsCopula = cqsCopula(c(input$a,input$b)),
                         frankCopula = checkFrank(input$paramFrank),
                         normalCopula = normalCopula(input$paramEllip),
                         gumbelCopula = rotateGumbel(input),
                         joeBiCopula = rotateJoe(input),
                         tCopula = tCopula(input$paramEllip, df=input$df),
                         tawnT1Copula = rotateTawnT1(input),
                         tawnT2Copula = rotateTawnT2(input),
                         spCopula = loadSpCop()))
  
  mar <- reactive(switch(input$margin,
                         unif = qunif,
                         norm = qnorm))
  
  corFun <- reactive({
      data(spCopDemo)
      calcKTauPol <- fitCorFun(bins, degree=3)
      
      return(curve(calcKTauPol, 0,1000, xlab="distance [m]", ylab="correlation [Kendall's tau]"))
  })
  
  
  output$corFunPlot <- renderPlot({
    if(class(cop()) == "spCopula") {
      plot(corFun(), type="l", xlab="spatial distance [m]", ylab="correlation [Kendall's tau]",
           main="correlation function for the Meuse data set")
      abline(v=input$spatialDistance, col="red")
    } else
      NULL
  })
  
  output$caption <- renderText(cop()@fullname)
  
  output$kendallsTau <- renderText({
    if(class(cop())!="spCopula")
      paste("Kendall's tau:", round(tau(cop()),2))
    else
      NULL
    })
  
  output$tailIndex <- renderText({
    if(class(cop())!="spCopula")
      paste("lower and upper tail dependence:", paste(round(tailIndex(cop()),2), collapse=", "))
    else
      NULL
  })
  
  output$copulaPlots <- renderPlot({
    par(mfrow=c(1,2))
    if (class(cop()) == "spCopula") {
      if(input$margin=="norm")
        spatialPerspGauss(cop(), h=input$spatialDistance,
                          xlab="x", ylab="y",
                          zlab="", main="bivariate density",
                          ticktype="detailed")
      else
        spatialPersp(cop(), h=input$spatialDistance,
                     xlab="x", ylab="y",
                     zlab="", main="strength of dependence",
                     ticktype="detailed")
    } else {
      if(input$margin=="norm") {
        perspGauss(cop(), xlab="x", ylab="y",
                   zlab="", main="bivariate density",
                   ticktype="detailed")
        if(input$sampleSize > 10)
          plot(qnorm(rCopula(input$sampleSize, cop())), asp=1, 
               main=paste("sample of size", input$sampleSize),
               xlab="x", ylab="y")
        else
          contourGauss(cop(), xlab="x", ylab="y")
      } else {
        persp(cop(), dCopula, xlab="u", ylab="v",
              zlab="", main="strength of dependence",
              ticktype="detailed")
        plot(rCopula(input$sampleSize, cop()), asp=1, 
             main=paste("sample of size", input$sampleSize),
             xlab="u", ylab="v")
      }
    }
  }, height="auto")
  
})