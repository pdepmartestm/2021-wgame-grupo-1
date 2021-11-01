import wollok.game.*

object juego
{
	var property lagrimas=0
	const alto=12
	const ancho=21
	const property puertaIzquierda = game.at(1,6)
	const property puertaDerecha = game.at(19,6)
	const property puertaArriba = game.at(10,10)
	const property puertaAbajo = game.at(10,1)
	
	method iniciar()
	{
		game.height(alto)
		game.width(ancho)
		game.addVisual(habitacion0)
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
	
	method finalizar()
	{
		game.clear()
		game.addVisual(cartel)
		game.onTick(5000,"finalizar",{game.stop()})
	}
}

class Habitacion
{
	const property position = game.at(0,0)
	
	method impactoLagrimaEnemiga() {}
	
	method impactaAIsaac() {}
	
	method impactoEnemigo() {}
	
	method impactoLagrimaIsaac() {}
	
	method left() {isaac.position(juego.puertaDerecha().left(1))}
	method right() {isaac.position(juego.puertaIzquierda().right(1))}
	method up() {isaac.position(juego.puertaAbajo().up(1))}
	method down() {isaac.position(juego.puertaArriba().down(1))}
	
	method image()
	{
		if (isaac.enemigos()==0)
		{
		return "habitacion"+isaac.numHabitacion()+"abierta.png"
		}
		else {
		return "habitacion"+isaac.numHabitacion()+"cerrada.png"
		}
	}
}

object habitacion0 inherits Habitacion
{	
	method aparecer(){}
	
	method cambiaHabitacion(orientacion)
	{
		if(orientacion == "left")
		{
			self.left()
			isaac.numHabitacion(1)
			return habitacion1
		}else
		if(orientacion == "right")
		{
			self.right()
			isaac.numHabitacion(3)
			return habitacion3
		}else
		if(orientacion == "up")
		{
			self.up()
			isaac.numHabitacion(2)
			return habitacion2
		}else
		if(orientacion == "down")
		{
			self.down()
			isaac.numHabitacion(4)
			return habitacion4
		}else {return self}
	}
}

object habitacion1 inherits Habitacion
{
	method aparecer()
	{
		if (not isaac.habitacionesHechas().any({number=> number==1}))
		{
		const enemigo = new Gaper()
		enemigo.aparecer(game.at(5,8),isaac.enemigos())
		
		const enemigo = new Gaper()
		enemigo.aparecer(game.at(8,8),isaac.enemigos())
		
		const enemigo = new Maw()
		enemigo.aparecer(game.at(5,3),isaac.enemigos())
		
		const enemigo = new Maw()
		enemigo.aparecer(game.at(8,3),isaac.enemigos())
		
		const enemigo = new Torre()
		enemigo.aparecer(game.at(2,2),isaac.enemigos())
		
		const enemigo = new Torre()
		enemigo.aparecer(game.at(2,9),isaac.enemigos())
		
		isaac.habitacionesHechas().add(1)
		}
		else{}
	}
	
	method cambiaHabitacion(orientacion)
	{
		if(orientacion == "right")
		{
			self.right()
			isaac.numHabitacion(0)
			return habitacion0
		}else {return self}
	}
	
}

object habitacion2 inherits Habitacion
{
	method aparecer()
	{

		if (not isaac.habitacionesHechas().any({number=> number==2}))
		{
		isaac.habitacionesHechas().add(2)
		
		const enemigo = new Torre()
		enemigo.aparecer(game.at(2,9),isaac.enemigos())
		
		const enemigo = new Torre()
		enemigo.aparecer(game.at(4,9),isaac.enemigos())

		const enemigo = new Torre()
		enemigo.aparecer(game.at(6,9),isaac.enemigos())

		const enemigo = new Torre()
		enemigo.aparecer(game.at(8,9),isaac.enemigos())

		const enemigo = new Torre()
		enemigo.aparecer(game.at(10,9),isaac.enemigos())

		const enemigo = new Torre()
		enemigo.aparecer(game.at(12,9),isaac.enemigos())

		const enemigo = new Torre()
		enemigo.aparecer(game.at(14,9),isaac.enemigos())

		const enemigo = new Torre()
		enemigo.aparecer(game.at(16,9),isaac.enemigos())

		const enemigo = new Torre()
		enemigo.aparecer(game.at(18,9),isaac.enemigos())
		}
		else{}	
	}
	
	method cambiaHabitacion(orientacion)
	{
		if(orientacion == "down")
		{
			self.down()
			isaac.numHabitacion(0)
			return habitacion0
		}else {return self}
	}
}
object habitacion3 inherits Habitacion
{
	method aparecer()
	{
		if (not isaac.item()) {		
		const item = new Objeto()
		item.aparecer([1,2,3].anyOne())}
		else{}
	}
	
	method cambiaHabitacion(orientacion)
	{
		if(orientacion == "left")
		{
			self.left()
			isaac.numHabitacion(0)
			return habitacion0
		}else {return self}
	}
}
object habitacion4 inherits Habitacion
{
	method aparecer()
	{			

		if(not isaac.habitacionesHechas().any({number=> number==4}))
		{
		isaac.habitacionesHechas().add(4)
			
		const enemigo = new Torre()
		enemigo.aparecer(game.at(3,3),isaac.enemigos())
			
		const enemigo = new Maw()
		enemigo.aparecer(game.at(4,3),isaac.enemigos())
			
		const enemigo = new Gaper()
		enemigo.aparecer(game.at(5,3),isaac.enemigos())
			
		const enemigo = new Gaper()
		enemigo.aparecer(game.at(15,3),isaac.enemigos())
			
		const enemigo = new Maw()
		enemigo.aparecer(game.at(16,3),isaac.enemigos())
			
		const enemigo = new Torre()
		enemigo.aparecer(game.at(17,3),isaac.enemigos())
		}
	}
		
		method cambiaHabitacion(orientacion)
	{
		if(orientacion == "up")
		{
			self.up()
			isaac.numHabitacion(0)
			return habitacion0
		}else {return self}
	}
}

object barraIsaac
{
	var property limite = 6
	const position = game.at(0.5,11)
	
	method image()
	{
		if (limite==6){return "Vida" + isaac.vida() + ".png"}
		else {return "Vida"+ isaac.vida() +"Ampliada.png"}
	}
	
	method position() {return position}
}

object isaac
{
	var item = false
	var property enemigos=0
	var property velAtaque = 100
	var property danio = 1
	var property position = game.center()
	var property vida = 6
	var property image = "isaac.png"
	var property habitacionActual = habitacion0
	var property numHabitacion = 0
	var property habitacionesHechas=[]
	
	method item(tieneItem){item = tieneItem}
	method item(){return item}
	
	method cambiaHabitacion(orientacion)
	{
		if(self.enemigos() == 0)
		{
			habitacionActual = habitacionActual.cambiaHabitacion(orientacion)
			habitacionActual.aparecer()
		}
	}
	
	method avanza(posicion)
	{
		if(self.enemigos() == 0)
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
		else {
			vida--
			juego.finalizar()
		}
	}
	
	method impactoLagrimaIsaac() {}
	
	method impactoEnemigo()
	{
		if (vida>1) {vida--}
		else {
			vida--
			juego.finalizar()
		}
	}
}

class Elemento
{
	var property position = null
	var property image = null
	var property evento = null
	var property evento2 = null
	
	method agarraItem(n){}
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
	
	method impactoEnemigo() {self.desaparecer()}
	
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
		game.onTick(isaac.velAtaque(),evento,{self.avanza(position.right(direccionX).up(direccionY))})
	}
}

class LagrimaEnemigo inherits Lagrima
{
	
	method disparar(posicion,direccionX,direccionY)
	{
		evento = "lagrimaEnemiga"+juego.lagrimas()
		image = "lagrimaenemigo.png"
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
			isaac.enemigos(isaac.enemigos()-1)
			self.desaparecer()
			if(isaac.enemigos() == 0 && isaac.habitacionesHechas().size() == 3) {juego.finalizar()}
			else if(isaac.enemigos() == 0) {
				const item = new Objeto()
				item.aparecer(4)
			}
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
		juego.lagrimas(juego.lagrimas()+1)
	}
}

class Gaper inherits Enemigo
{
	method aparecer(posicion,nro)
	{
		isaac.enemigos(isaac.enemigos()+1)
		position = posicion
		image = "enemigo1.png"
		evento = "perseguir"+nro
		game.addVisual(self)
		game.onTick(500,evento,{self.perseguir(isaac)})
	}
}

class Maw inherits Enemigo
{
	method aparecer(posicion,nro)
	{
		isaac.enemigos(isaac.enemigos()+1)
		position = posicion
		image = "maw.png"
		evento = "perseguir"+nro
		evento2 = "disparar"+nro
		game.addVisual(self)
		game.onTick(1000,evento,{self.perseguir(isaac)})
		game.onTick(2000,evento2, {self.disparar(isaac)})
	}
}

class Torre inherits Enemigo
{
	method aparecer(posicion,nro)
	{
		isaac.enemigos(isaac.enemigos()+1)
		position = posicion
		image = "torre2.png"
		evento = "levantarse"+nro
		evento2 = "disparar"+nro
		game.addVisual(self)
		game.onTick(800,evento,{self.trakear(isaac)})
		game.onTick(2000,evento2, {self.disparar(isaac)})
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
	
	method aparecer(posicion,orientacion)
	{
		position=posicion
		image="void.png"
		game.addVisual(self)
		game.onCollideDo(self,{elemento=>elemento.cambiaHabitacion(orientacion)})
	}
}

class Objeto inherits Elemento
{
	var nroObjeto=null
	method impactoLagrimaEnemiga() {}
	
	method impactaAIsaac() 
	{
		if(nroObjeto != 4) {isaac.item(true)}
		game.removeVisual(self)
		if (nroObjeto == 1){isaac.danio(isaac.danio()+5) game.say(isaac, "5 de danio")}
		if (nroObjeto == 2)
		{
			isaac.vida(isaac.vida()+2)
			game.say(isaac, "mas vida")
			barraIsaac.limite(barraIsaac.limite() + 2)
		}
		if (nroObjeto == 3)
		{
			isaac.velAtaque(isaac.velAtaque()-50)
			game.say(isaac,"las lagrimas van mas rapido")
		}
		if (nroObjeto == 4){if(isaac.vida() <= 4) {isaac.vida(isaac.vida()+2)} else {isaac.vida(6)}}
		
		isaac.enemigos(isaac.enemigos()-1)
		
	}
	
	method impactoEnemigo() {}
	
	method impactoLagrimaIsaac() {}
	
	method aparecer(nroItem)
	{
		nroObjeto = nroItem
		isaac.enemigos(isaac.enemigos()+1)
		position=game.center()
		image="Item"+nroItem+".png"
		game.addVisual(self)
	}
	
}

object cartel
{
	const property position = game.origin()
	
	method image()
	{
		if(isaac.vida() == 0) {return "gameOver.png"}
		else {return "win.png"}
	}
}