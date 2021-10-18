import wollok.game.*

object juego
{
	const alto=10
	const ancho=20
	
	method iniciar()
	{
		game.height(alto)
		game.width(ancho)
		game.addVisual(isaac)
		
		keyboard.w().onPressDo({isaac.moverseArriba()})
		keyboard.a().onPressDo({isaac.moverseIzquierda()})
		keyboard.s().onPressDo({isaac.moverseAbajo()})
		keyboard.d().onPressDo({isaac.moverseDerecha()})
		
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
		
		game.start()
	}
	
	method estaEnLaPantalla(posicion)
	{
		return (posicion.x() >= 0 && posicion.x() <= ancho) && (posicion.y() >= 0 && posicion.y() <= alto)
	}
}

object isaac
{
	var property danio = 1
	var property position = game.center()
	var property vida = 5
	
	method image() {return "isaac.png"}
	
	method position() {return position}
	
	method moverseIzquierda() {position=position.left(1)}
	method moverseDerecha() {position=position.right(1)}
	method moverseArriba() {position=position.up(1)}
	method moverseAbajo() {position=position.down(1)}
	
	
}

class Elemento
{
	var property position = null
	var property image = null
	var property evento = null
	
	method desaparecer()
	{
		if(game.hasVisual(self))
		{
			game.removeVisual(self)
		}
	}
}

class Lagrima inherits Elemento
{
	method impactoLagrimaEnemiga() {}
	
	method impactaAIsaac() {}
	
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
		image = "lagrima.png"
		position = isaac.position().right(direccionX).up(direccionY)
		game.addVisual(self)
		game.onCollideDo(self,{elemento=>elemento.impactoLagrimaIsaac(self)})
		game.onTick(50,evento,{self.avanza(position.right(direccionX).up(direccionY))})
	}
}

class Enemigo inherits Elemento
{
	var property vida = 5
	
	method impactoLagrimaEnemiga() {}
	
	method impactoLagrimaIsaac()
	{
		vida = vida - isaac.danio()
		if(vida <= 0) {self.desaparecer()}
	}
	
	method impactaAIsaac()
	{
		isaac.vida(isaac.vida() - 1)
	}
	
	method avanza(posicion)
	{
		if(juego.estaEnLaPantalla(posicion))
		{
			position = posicion
		}
	}
}

class Gaper inherits Enemigo
{
	method aparecer(posicion)
	{
		position = posicion
		image = "gaper.png"
		evento = "perseguir"
		game.addVisualIn(self,posicion)
		game.onTick(200,evento,{self.perseguir(isaac)})
	}
	
	method perseguir(elemento)
	{
		if(elemento.position().x() > position.x()) {self.avanza(position.right(1))}
		if(elemento.position().x() < position.x()) {self.avanza(position.left(1))}
		if(elemento.position().y() > position.y()) {self.avanza(position.up(1))}
		if(elemento.position().y() < position.y()) {self.avanza(position.down(1))}
		game.say(self,"hola")
	}
}