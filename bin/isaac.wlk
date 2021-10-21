import wollok.game.*

object juego
{
	const alto=10
	const ancho=20
	
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
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(-1,0)
		})
		keyboard.right().onPressDo
		({
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(1,0)
		})
		keyboard.up().onPressDo
		({
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(0,1)
		})
		keyboard.down().onPressDo
		({
			const lagrima = new LagrimaIsaac()
			lagrima.disparar(0,-1)
		})
			const puerta1 = new Puerta()
			puerta1.aparecer(game.at(2,4),"izquierda")
			const puerta2 = new Puerta()
			puerta2.aparecer(game.at(17,4),"derecha")
			const puerta3 = new Puerta()
			puerta3.aparecer(game.at(9,8),"arriba")
			const puerta4 = new Puerta()
			puerta4.aparecer(game.at(9,2),"abajo")			
		game.onCollideDo(isaac,{algo => algo.impactaAIsaac()})
		
		game.start()
	}
	
	method estaEnLaPantalla(posicion)
	{
		return posicion.x() >= 2 && posicion.x() < ancho-2 && posicion.y() >= 2 && posicion.y() < alto-1
	}

	
}

object habitacion
{
	var property enemigos=0
	const position = game.at(0,0)
	const image = "habitacion.png"
	method position(){return position}
	method image(){return image}

	method enemigos(){return enemigos}
	method habitacion0(){}
	method habitacion1(){
	const enemigo = new Gaper()
	enemigo.aparecer(game.at(5,5))
	const enemigo2 = new Maw()
	enemigo2.aparecer(game.at(15,5))
	const enemigo3 = new Torre()
	enemigo3.aparecer(game.at(3,3))
	}
	method habitacion2(){}
	method habitacion3(){}
	method habitacion4(){}	
}

object barraIsaac
{
	const position = game.at(0.5,9)
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
	var nhabitacion = 0
	method image() {return image}
	method position() {return position}
	method position(posicion){return posicion}
	
	method cambiaHabitacion(orientacion){
		if (nhabitacion==0 && orientacion=="izquierda" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 1 
			position=game.at(18-position.x(),10-position.y())
			habitacion.habitacion1()		
		}
		if (nhabitacion==1 && orientacion=="derecha" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 0 
			position=game.at(18-position.x(),10-position.y())
			habitacion.habitacion0()		
		}
		if (nhabitacion==0 && orientacion=="arriba" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 2 
			position=game.at(18-position.x(),10-position.y())
			habitacion.habitacion2()		
		}
		if (nhabitacion==2 && orientacion=="abajo" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 0 
			position=game.at(18-position.x(),10-position.y())
			habitacion.habitacion0()		
		}
		if (nhabitacion==0 && orientacion=="derecha" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 3 
			position=game.at(18-position.x(),10-position.y())
			habitacion.habitacion3()		
		}
		if (nhabitacion==3 && orientacion=="izquierda" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 0 
			position=game.at(18-position.x(),10-position.y())
			habitacion.habitacion0()		
		}
		if (nhabitacion==0 && orientacion=="abajo" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 4 
			position=game.at(18-position.x(),10-position.y())
			habitacion.habitacion4()		
		}
		if (nhabitacion==4 && orientacion=="arriba" && habitacion.enemigos() == 0)
		{	
			nhabitacion = 0 
			position=game.at(18-position.x(),10-position.y())
			
			habitacion.habitacion0()		
		}
	}
	method avanza(posicion)
	{
		if(juego.estaEnLaPantalla(posicion)) {position = posicion}
	}
    method impactoLagrimaEnemiga()
	{
		
		if (vida>1)
		{
			vida--
		}
		else{
			game.stop()
	}
	}
	method impactoLagrimaIsaac()
	{}
	method impactoEnemigo()
	{
		
		if (vida>1)
		{
			vida--
		}
		else{
			game.stop()
		}
		
		
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
			game.removeTickEvent(evento)
			game.removeTickEvent(evento2)
			game.removeVisual(self)
		}
	}
}

class Lagrima inherits Elemento
{
	method impactoLagrimaEnemiga() {}
	
	method impactaAIsaac() {}
	
	method impactoEnemigo() {}
	
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
		evento = "lagrimaIsaac"
		evento2 = "ningunevento"
		image = "lagrima.png"
		position = isaac.position().right(direccionX).up(direccionY)
		game.addVisual(self)
		game.onCollideDo(self,{elemento=>elemento.impactoLagrimaIsaac()})
		game.onTick(100000000000,evento2,{})
		game.onTick(50,evento,{self.avanza(position.right(direccionX).up(direccionY))})
	}
}

class LagrimaEnemigo inherits Lagrima
{
	method disparar(posicion,direccionX,direccionY)
	{
		evento = "lagrimaEnemiga"
		image= "lagrimaenemigo.png"
		evento2 = "ningunevento"
		position = posicion
		game.addVisual(self)
		game.onCollideDo(self,{elemento=>elemento.impactoLagrimaEnemiga()})
		game.onTick(100000000000,evento2,{})
		game.onTick(200,evento,{self.avanza(position.right(direccionX).up(direccionY))})
	}
}

class Enemigo inherits Elemento
{
	var property vida = 10
	
	method impactoLagrimaEnemiga() {}
	
	method impactoLagrimaIsaac()
	{
		vida = vida - isaac.danio()
		if(vida <= 0) {
			habitacion.enemigos(habitacion.enemigos()-1)
			self.desaparecer()
		}
	}
	
	method impactaAIsaac() {
	isaac.impactoEnemigo()
	}
	
	method avanza(posicion)
	{
		if(juego.estaEnLaPantalla(posicion))
		{
			position = posicion
		}
	}
	method trakear (elemento)
	{
			if(elemento.position().x() == self.position().x() || elemento.position().y() == self.position().y())
			{	
				image="torre1.png"
			}
			else(image="torre2.png")
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
		evento2 = "ningunevento"
		game.addVisual(self)
		game.onTick(100000000000,evento2,{})
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
		evento = "perseguir"
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