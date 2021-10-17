import wollok.game.*

object pantalla
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
			const bala1 = new Bala(posicion=isaac.posicion(),velocidad=isaac.velocidadBala())
			game.addVisual(bala1)
			bala1.moverseIzquierda()
		})
		keyboard.right().onPressDo
		({
			const bala2 = new Bala(posicion=isaac.posicion().right(),velocidad=isaac.velocidadBala())
			game.addVisual(bala2)
			bala2.moverseDerecha()
		})
		keyboard.up().onPressDo
		({
			const bala3 = new Bala(posicion=isaac.posicion(),velocidad=isaac.velocidadBala())
			game.addVisual(bala3)
			bala3.moverseArriba()
		})
		keyboard.down().onPressDo
		({
			const bala4 = new Bala(posicion=isaac.posicion(),velocidad=isaac.velocidadBala())
			game.addVisual(bala4)
			bala4.moverseAbajo()
		})
		
		game.start()
	}
}

object isaac
{
	var property posicion = game.center()
	var property velocidadBala = 100
	
	method position() 
	{
		return posicion
	}
	
	method image()
	{
		return "isaac.png"
	}
	
	method moverseIzquierda()
	{
		posicion=posicion.left(1)
	}
	method moverseDerecha()
	{
		posicion=posicion.right(1)
	}
	method moverseArriba()
	{
		posicion=posicion.up(1)
	}
	method moverseAbajo()
	{
		posicion=posicion.down(1)
	}
}

class Bala
{
	var posicion
	var property velocidad
	
	method image()
	{
		return "bala.png"
	}
	
	method position()
	{
		return posicion
	}
	
	method moverseIzquierda()
	{
		game.onTick(velocidad, "movimiento bala",{posicion=posicion.left(1)})
	}
	method moverseDerecha()
	{
		game.onTick(velocidad, "movimiento bala", {posicion=posicion.right(1)})
	}
	method moverseArriba()
	{
		game.onTick(velocidad, "movimiento bala", {posicion=posicion.up(1)})
	}
	method moverseAbajo()
	{
		game.onTick(velocidad, "movimiento bala", {posicion=posicion.down(1)})
	}
}

class Gaper
{
	var velocidad = 100
	var posicion
	
	method position()
	{
		return posicion
	}
	
	method image()
	{
		return "gaper.png"
	}
	
	method perseguir(presa)
	{
		
	}
}

