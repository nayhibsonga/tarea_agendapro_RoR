class WelcomeController < ApplicationController
	def new
	  @usuario = Usuario.new
	end

	def index
	  @usuarios = Usuario.all
	  @apuestas=[]
	  @ruleta = []
	  @opcion_ruleta = rand(0..99)
	  @ganadores = []
	  @perdedores = []
	  @opciones = ["Negro","Rojo","Verde"]
		for i in 0..99
		   	if(i <= 49)
		   		@ruleta.push({"name" => "Negro"})
		   	elsif(i <= 98)
		   		@ruleta.push({"name" => "Rojo"})
		   	else
		   		@ruleta.push({"name" => "Verde"})
		   	end
		end
		@resultado_ruleta = @ruleta[@opcion_ruleta]["name"]
		@usuarios.each do |usuario|
			@porcentaje = rand(8..15)
			@opciones_apuesta = rand(0..99)
			@nombre_apostador = usuario.nombre
			@apellido_apostador = usuario.apellido
			@dinero = usuario.Dinero
			@id = String(usuario.id)
			if(@dinero > 0)
				if(@dinero <= 1000)
					@apuesta = @dinero
				else
					@apuesta = @dinero*@porcentaje/100
				end
				@apuestas.push({"Nombre"=>@nombre_apostador,"Apellido"=>@apellido_apostador,"Apuesta" => @apuesta, "Color" => @ruleta[@opciones_apuesta]["name"]})
				if(@ruleta[@opciones_apuesta]["name"]==@resultado_ruleta)
					if(@resultado_ruleta == "Verde")
						@ganancia = @apuesta * 15
					else
						@ganancia = @apuesta * 2
					end
					@suma = @dinero+@ganancia
					Usuario.where("id IN ("+@id+")").update_all(:Dinero => @suma)
					@ganadores.push("Nombre" => @nombre_apostador, "Ganancia" => @ganancia)
				else
					@ganancia = @apuesta
					@suma = @dinero-@ganancia
					Usuario.where("id IN ("+@id+")").update_all(:Dinero => @suma)
					@perdedores.push("Nombre" => @nombre_apostador, "Perdida" => @ganancia)
				end
			end

		end
		@usuarios = Usuario.all
	  #Usuario.where("Dinero >= 1000").update_all(:Dinero => @nayhib - 1000)
	end

	def create
	  @usuario = Usuario.new(params[:usuario].permit(:nombre, :apellido,:Dinero))
	  @usuario.save
	  redirect_to welcome_index_path    # esta ruta se explica a continuación
	end
	def viewUpdate
		@id_obtenido = params[:id]
		@usuarios = Usuario.find(@id_obtenido)
		@nombre_apostador = @usuarios.nombre
		@apellido_apostador = @usuarios.apellido
		@dinero_apostador = @usuarios.Dinero
		@id = @usuarios.id
	end
	def update
		@id = params['usuario']['id']
		Usuario.where("id IN ("+@id+")").update_all(params[:usuario].permit(:nombre, :apellido,:Dinero))
		redirect_to welcome_index_path
	end
	def delete
		@id = params[:id]
		Usuario.where("id IN ("+@id+")").delete_all
		redirect_to welcome_index_path
	end
end
