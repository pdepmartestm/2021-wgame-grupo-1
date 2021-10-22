import wollok.game.*

object juego
{
	var lagrimas=0
	const alto=12
	const ancho=21
	const property puertaIzquierda = game.at(1,6)
	const property puertaDerecha = game.at(19,6)
	const property puertaArriba = game.at(10,10)
	const property puertaAbajo = game.at(10,1)
	
	method lagrimas(){return lagrimas}
	method iniciar()
	{
		game.height(alto)
		game.width(ancho)
		game.addVisual(habitacion)
		game.addVisual(isaac)
		game.addVisual(barraIsaac)
		
		keyboard.w().onPressDo({isaac.avanza(isaac.position().up(1))})
		keyboard.a().onPressDo({isaac.avanza(isaac.position().left(1))})
		keyboard.s().onPressDo({isaac.avanza(isaac.position().down(1))})
		keyboard.d().onPressDo({isaac.avanza(isaac.position().right(1))})
		
		keyboard.left().onPressDo
		({
			lagrimas++
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(-1,0)
		})
		keyboard.right().onPressDo
		({
			lagrimas++
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(1,0)
		})
		keyboard.up().onPressDo
		({
			lagrimas++
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(0,1)
		})
		keyboard.down().onPressDo
		({
			lagrimas++
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(0,-1)
		})
			
		const puertaLeft = new Puerta()
		puertaLeft.aparecer(puertaIzquierda,"left")
		const puertaRight = new Puerta()
		puertaRight.aparecer(puertaDerecha,"right")
		const puertaUp = new Puerta()
		puertaUp.aparecer(puertaArriba,"up")
		const puertaDown = new Puerta()
		puertaDown.aparecer(puertaAbajo,"down")
					
		game.onCollideDo(isaac,{algo => algo.impactaAIsaac()})
		
		game.start()
	}
	
	method estaEnLaPantalla(posicion)
	{
		return posicion.x() >= 2 && posicion.x() < ancho-2 && posicion.y() >= 2 && posicion.y() < alto-2
	}

	
}

object habitacion
{
	var property enemigos=0
	const property position = game.at(0,0)
	var image = "habitacion0abierta.png"
	
	method image()
	{
		if(enemigos == 0) {return "habitacion" + isaac.numHabitacion() + "abierta.png"}
		else {return "habitacion" + isaac.numHabitacion() + "cerrada.png"}
	}

	method habitacion0(){}
	method habitacion1(){
	const enemigo = new Gaper()
	enemigo.aparecer(game.at(5,8))
	const enemigo2 = new Maw()
	enemigo2.aparecer(game.at(15,8))
	const enemigo3 = new Torre()
	enemigo3.aparecer(game.at(3,3))
	}
	
	method habitacion2(){}
	
	method habitacion3(){}
	
	method habitacion4(){}	
}

object barraIsaac
{
	const position = game.at(0.5,11)
	method image(){
		return "Vida" + isaac.vida() + ".png"
	}
	method position(){
		return position
	}
}

object isaac
{
	var property danio = 1
	var property position = game.center()
	var property vida = 6
	var property image = "isaac.png"
	var property numHabitacion = 0
	
	method position(posicion){return posicion}
	
	method cambiaHabitacion(orientacion)
	{
		if(habitacion.enemigos() == 0)
		{
			if (numHabitacion==0 && orientacion=="left")
			{	
				game.say(self, "entre a la habitacion 1")
				numHabitacion = 1 
				position= juego.puertaDerecha().left(1)
				habitacion.habitacion1()		
			}
			else if (numHabitacion==1 && orientacion=="right")
			{	
				game.say(self, "entre a la habitacion 0 desde la 1")
				position= juego.puertaIzquierda().right(1)
				habitacion.habitacion0()		
				numHabitacion = 0 
			}
			else if (numHabitacion==0 && orientacion=="up")
			{	
				game.say(self, "entre a la habitacion 2")
				numHabitacion = 2 
				position= juego.puertaAbajo().up(1)
				habitacion.habitacion2()		
			}
			else if (numHabitacion==2 && orientacion=="down")
			{	
				game.say(self, "Volvi de la 2")
				position= juego.puertaArriba().down(1)
				habitacion.habitacion0()		
				numHabitacion = 0 
			}
			else if (numHabitacion==0 && orientacion=="right")
			{	
				game.say(self, "entre a la habitacion 3")
				numHabitacion = 3 
				position= juego.puertaIzquierda().right(1)
				habitacion.habitacion3()		
			}
			else if (numHabitacion==3 && orientacion=="left")
			{	
				game.say(self, "volvi de la 3")
				numHabitacion = 0 
				position= juego.puertaDerecha().left(1)
				habitacion.habitacion0()		
			}
			else if (numHabitacion==0 && orientacion=="down")
			{	
				game.say(self, "entre a la habitacion 4")
				numHabitacion = 4 
				position= juego.puertaArriba().down(1)
				habitacion.habitacion4()		
			}
			else if (numHabitacion==4 && orientacion=="up")
			{	
				game.say(self, "volvi de la 4")
				numHabitacion = 0 
				position= juego.puertaAbajo().up(1)
				
				habitacion.habitacion0()		
			}
		}
	}
	
	method avanza(posicion)
	{
		if(habitacion.enemigos() == 0)
		{
			if(posicion == juego.puertaIzquierda() || posicion == juego.puertaDerecha() || posicion == juego.puertaArriba() || posicion == juego.puertaAbajo())
			{
				position = posicion
			} else {if(juego.estaEnLaPantalla(posicion)) {position = posicion}}
		} else {if(juego.estaEnLaPantalla(posicion)) {position = posicion}}
	}
	
    method impactoLagrimaEnemiga()
	{
		if (vida>1) {vida--}
		else {game.stop()}
	}
	
	method impactoLagrimaIsaac() {}
	
	method impactoEnemigo()
	{
		if (vida>1) {vida--}
		else {game.stop()}
	}
}

class Elemento
{
	var property position = null
	var property image = null
	var property evento = null
	var property evento2 = null
	
	method cambiaHabitacion(a){}
	method desaparecer()
	{
		if(game.hasVisual(self))
		{
			if(evento != null) {game.removeTickEvent(evento)}
			if(evento2 != null) {game.removeTickEvent(evento2)}
			game.removeVisual(self)
		}
	}
}

class Lagrima inherits Elemento
{
	method impactoLagrimaEnemiga() {}
	
	method impactaAIsaac() {}
	
	method impactoEnemigo() {
		 self.desaparecer()
	}
	
	method impactoLagrimaIsaac() {}
	
	method danio() = 1
	
	method avanza(posicion)
	{
		if(juego.estaEnLaPantalla(posicion))
		{
			position = posicion
		}else
		{
			self.desaparecer()
		}
	}
}

class LagrimaIsaac inherits Lagrima
{
	override method danio() = isaac.danio()

	method disparar(direccionX,direccionY) //
	{
		evento = "lagrimaIsaac"+juego.lagrimas()
		image = "lagrima.png"
		position = isaac.position().right(direccionX).up(direccionY)
		game.addVisual(self)
		game.onCollideDo(self,{elemento=>elemento.impactoLagrimaIsaac()})
		game.onTick(100,evento,{self.avanza(position.right(direccionX).up(direccionY))})
	}
}

class LagrimaEnemigo inherits Lagrima
{
	method disparar(posicion,direccionX,direccionY)
	{
		evento = "lagrimaEnemiga"
		image= "lagrimaenemigo.png"
		position = posicion
		game.addVisual(self)
		game.onCollideDo(self,{elemento=>elemento.impactoLagrimaEnemiga()})
		game.onTick(200,evento,{self.avanza(position.right(direccionX).up(direccionY))})
	}
}

class Enemigo inherits Elemento
{
	var property vida = 15
	
	method impactoLagrimaEnemiga() {}
	
	method impactoLagrimaIsaac()
	{
		vida = vida - isaac.danio()
		if(vida <= 0) 
		{
			habitacion.enemigos(habitacion.enemigos()-1)
			self.desaparecer()
		}
	}
	
	method impactaAIsaac() {isaac.impactoEnemigo()}
	
	method avanza(posicion)
	{
		if(juego.estaEnLaPantalla(posicion))
		{
			position = posicion
		}
	}
	
	method perseguir(elemento)
	{
		if(elemento.position().x() > self.position().x()) {self.avanza(position.right(1))}
		if(elemento.position().x() < self.position().x()) {self.avanza(position.left(1))}
		if(elemento.position().y() > self.position().y()) {self.avanza(position.up(1))}
		if(elemento.position().y() < self.position().y()) {self.avanza(position.down(1))}
	}
	
	method disparar(elemento)
	{
		if(elemento.position().x() == self.position().x() && elemento.position().y() > self.position().y()) {const lagrima = new LagrimaEnemigo()
			lagrima.disparar(position,0,1)}
		if(elemento.position().x() == self.position().x() && elemento.position().y() < self.position().y()) {const lagrima = new LagrimaEnemigo()
			lagrima.disparar(position,0,-1)}
		if(elemento.position().y() == self.position().y() && elemento.position().x() > self.position().x()) {const lagrima = new LagrimaEnemigo()
			lagrima.disparar(position,1,0)}
		if(elemento.position().y() == self.position().y() && elemento.position().x() < self.position().x()) {const lagrima = new LagrimaEnemigo()
			lagrima.disparar(position,-1,0)}
	}
}

class Gaper inherits Enemigo
{
	method aparecer(posicion)
	{
		habitacion.enemigos(habitacion.enemigos()+1)
		position = posicion
		image = "enemigo1.png"
		evento = "perseguir"
		game.addVisual(self)
		game.onTick(700,evento,{self.perseguir(isaac)})
	}
}

class Maw inherits Enemigo
{
	method aparecer(posicion)
	{
		habitacion.enemigos(habitacion.enemigos()+1)
		position = posicion
		image = "maw.png"
		evento = "perseguir1"
		evento2 = "disparar"
		game.addVisual(self)
		game.onTick(1000,evento,{self.perseguir(isaac)})
		game.onTick(3000,evento2, {self.disparar(isaac)})
	}
}

class Torre inherits Enemigo
{
	method aparecer(posicion)
	{
		habitacion.enemigos(habitacion.enemigos()+1)
		position = posicion
		image = "torre2.png"
		evento = "levantarse"
		evento2 = "disparar"
		game.addVisual(self)
		game.onTick(800,evento,{self.trakear(isaac)})
		game.onTick(3000,evento2, {self.disparar(isaac)})
	}
	
	method trakear (elemento)
	{
		if(elemento.position().x() == self.position().x() || elemento.position().y() == self.position().y())
		{	
			image="torre1.png"
		}
		else {image="torre2.png"}
	}
}

class Puerta inherits Elemento
{
	method impactoLagrimaEnemiga() {}
	
	method impactaAIsaac() {}
	
	method impactoEnemigo() {}
	
	method impactoLagrimaIsaac() {}
	
	method aparecer(posicion,orientacion){
	position=posicion
	image="void.png"
	game.addVisual(self)
	game.onCollideDo(self,{elemento=>elemento.cambiaHabitacion(orientacion)})
	}
}