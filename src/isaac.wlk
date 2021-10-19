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
		
		const enemigo = new Gaper()
		enemigo.aparecer(game.at(5,5))
		
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
	const position = game.at(0,0)
	var image = "habitacion.png"
	method position(){return position}
	method image(){return image}
}
object barraIsaac
{
	const position = game.at(0.5,9)
	var image = "Vida6.png"
	var proxImage = "Vida5.png"
	method image(){
		return image
	}
	method position(){
		return position
	}
	method recibeDanio(vida){
		proxImage = "Vida"+vida+".png"
		image = proxImage 
	}
	method seCura(){
		
	}
}
object isaac
{
	var property danio = 1
	var property position = game.center()
	var property vida = 6
	var valor = "6"
	var property image = "isaac.png"
	method image() {return image}
	method position() {return position}
	
	method avanza(posicion)
	{
		if(juego.estaEnLaPantalla(posicion)) {position = posicion}
	}

	method impactoEnemigo()
	{
		
		if (vida>1)
		{vida--valor = vida
		barraIsaac.recibeDanio(valor)}
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
	
	method desaparecer()
	{
		if(game.hasVisual(self))
		{
			game.removeTickEvent(evento)
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
		image = "lagrima.png"
		position = isaac.position().right(direccionX).up(direccionY)
		game.addVisual(self)
		game.onCollideDo(self,{elemento=>elemento.impactoLagrimaIsaac()})
		game.onTick(50,evento,{self.avanza(position.right(direccionX).up(direccionY))})
	}
}

class Enemigo inherits Elemento
{
	var property vida = 10
	
	method impactoLagrimaEnemiga() {}
	
	method impactoLagrimaIsaac()
	{
		vida = vida - isaac.danio()
		if(vida <= 0) {self.desaparecer()}
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
}

class Gaper inherits Enemigo
{
	method aparecer(posicion)
	{
		position = posicion
		image = "gaper.png"
		evento = "perseguir"
		game.addVisual(self)
		game.onTick(1000,evento,{self.perseguir(isaac)})
	}
	
	method perseguir(elemento)
	{
		if(elemento.position().x() > self.position().x()) {self.avanza(position.right(1))}
		if(elemento.position().x() < self.position().x()) {self.avanza(position.left(1))}
		if(elemento.position().y() > self.position().y()) {self.avanza(position.up(1))}
		if(elemento.position().y() < self.position().y()) {self.avanza(position.down(1))}
	}
}