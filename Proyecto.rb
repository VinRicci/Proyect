require 'terminal-table'


cola_autores = {
    tope: nil,
    fondo: nil,
    max: 5
}

cola_ventas = {
    tope: nil,
    fondo: nil,
    vacia: true,
    max: 20
}

def limpiar_pantalla
    system ('clear')
end

def titulo
    puts 'RUBY BOOKSTORE'
    puts '--------------'
    puts ''
end

def size(cola)
    tamano = 0
    a = cola[:tope]
    while a != nil
        tamano += 1
        a = a[:siguiente]
    end
    return tamano
end

def llena?(cola)
    if size(cola) == cola[:max]
        return true
    else
        return false
    end
end

def vacia?(cp)
    if cp[:tope] == nil
        return true
    else
        return false
    end
end

def buscar(cp, buscado, tipo)
    a = cp[:tope]
    while a != nil
        if a[tipo] == buscado
            break
        else
            a = a[:siguiente]
        end
    end
    return a
end

def buscar_libro(cola_autores, isbn)
    a = cola_autores[:tope]
    while a != nil
        if buscar(a,isbn,:isbn) == nil
            a = a[:siguiente]
        else
            a = buscar(a,isbn,:isbn)
            break
        end
    end
    return a
end

def registro_libros(cola_autores)
    limpiar_pantalla 
    titulo
    puts 'Ingrese ISBN:'
    isbn = gets.chomp.to_i

    a = buscar_libro(cola_autores, isbn) 
    if a != nil
        a[:existencias] += 1
        return
    else
        puts 'Ingrese Nombre del Autor:'
        autor = gets.chomp
        if buscar(cola_autores,autor,:nombre) == nil && llena?(cola_autores) == true
            puts ' -------------------'
            puts '|AUTOR NO REGISTRADO|' 
            puts '|COLA LLENA         |'
            puts ' -------------------'
            return
        end
    end

    puts 'Ingrese Nombre del Libro:'
    nombre = gets.chomp
    puts 'Ingrese Precio:'
    precio = gets.chomp.to_i

    a = cola_autores[:tope]
    
    elementolibro = {
        nombre: nombre,
        existencias: 1,
        precio: precio,
        isbn: isbn,
        siguiente: nil,
        autor: autor
    }
    pilaautor = {
        nombre: autor,
        tope: elementolibro,
        siguiente: nil
    }

    begin
        if a == nil
            cola_autores[:tope] = pilaautor
            cola_autores[:fondo] = pilaautor
            return
        elsif a[:nombre] == autor
            break
        elsif a[:siguiente] == nil
            a[:siguiente] = pilaautor
            cola_autores[:fondo] = pilaautor
            return
        else
            a = a[:siguiente]
        end
    end while a != nil

    b = a[:tope]
    begin
        if b == nil
            a[:tope] = elementolibro
            break
        elsif b[:siguiente] == nil
            elementolibro[:siguiente] = a[:tope]
            a[:tope] = elementolibro
            break
        else
            b = b[:siguiente]
        end
    end while b != nil
end

def registro_autores(cola_autores)
    limpiar_pantalla
    if llena?(cola_autores) == true
        puts ' ------------------'
        puts '|COLA AUTORES LLENA|'
        puts ' ------------------'
    else
        puts 'Ingrese Nombre del Autor:'
        nombre = gets.chomp

        a = buscar(cola_autores,nombre,:nombre)
        if a != nil
            puts 'AUTOR YA REGISTRADO'            
            return
        end

        pilaautor = {
            nombre: nombre,
            tope: nil,
            siguiente: nil
        }

        a = cola_autores[:tope]
        begin
            if a == nil
                cola_autores[:tope] = pilaautor
                cola_autores[:fondo] = pilaautor
                break
            elsif a[:nombre] == nombre
                puts 'NOMBRE YA REGISTRADO'
                break
            elsif a[:siguiente] == nil
                a[:siguiente] = pilaautor
                cola_autores[:fondo] = pilaautor
                break
            else
                a = a[:siguiente]
            end
        end while a != nil
    end
end

def ingreso_buscar_libro(cola_autores)
    limpiar_pantalla
    titulo
    rows = []
    if vacia?(cola_autores)
        puts 'BASE DE DATOS VACIA'
   else
        puts 'Ingrese ISBN de Libro:'
        isbn = gets.chomp.to_i
        a = buscar_libro(cola_autores, isbn)
        if a == nil
            puts 'LIBRO NO REGISTRADO'
        else
        rows << [a[:nombre], a[:existencias], isbn, a[:precio],a[:autor]]
        table = Terminal::Table.new :rows => rows 
        table.headings = ['Nombre', 'Existencia', 'ISBN', 'Precio', 'Autor']
        puts table
        end
    end
end

def ingreso_buscar_autor(cola_autores)
    limpiar_pantalla
    titulo
    if vacia?(cola_autores) == true
        puts 'BASE DE DATOS VACIA'
    else
        puts 'Ingrese Nombre del Autor: '
        nombreautor = gets.chomp
        elemento = {}
        aux = cola_autores[:tope]
        rows = []
    loop do
        if  nombreautor == aux[:nombre]
            elemento = aux
            break
        elsif aux[:siguiente] == nil
            break
        else
            aux = aux[:siguiente]
        end
    end
    puts "Autor: #{elemento[:nombre]}"
    elemento = elemento[:tope]
    
    loop do
        rows << [elemento[:nombre], elemento[:existencias]]
        elemento = elemento[:siguiente]
        if elemento == nil
            break
        end
    end
    table = Terminal::Table.new :rows => rows 
    table.headings = ['Libros', 'Existencias']
    puts table
    end
end


def registro_ventas(cola_autores, cola_ventas,conty)
    limpiar_pantalla
    puts '¿Cuántos libros desea adquirir?'
    vent = gets.chomp.to_i
    total = 0
    
    for j in 1..vent 
        puts 'Ingrese Código ISBN'
        code = gets.chomp.to_i 
        a = buscar_libro(cola_autores,code)

        if a == nil
            puts 'LIBRO NO REGISTRADO'
        elsif a[:existencias] < 1
            puts 'No Quedan Existencias de este Ejemplar'
        else
            puts a[:nombre]
            puts "Precio:"
            total = total + a[:precio]
            puts a[:precio]      
            puts "VENTA REALIZADA"
        end
        gets 
    end

    puts " "
    puts "Subtotal: "
    puts "Q.#{total}"
    
    if vent == 3
        subtotal = total*0.10
        total = total - subtotal
    end
    if vent > 3
        subtotal = total*0.20
        total = total - subtotal
    end
    if vent < 3
        subtotal = total*0.05
        total = total - subtotal
    end


    puts " "
    puts "Total con Descuento: "
    puts "Q.#{total}"
    gets

        if cola_ventas[:vacia] = true
          elemento = {
            ISBN: conty,
            libro: a,
            total: total,
            siguiente: nil
          }
          
          cola_ventas[:tope] = elemento
          cola_ventas[:fondo] = elemento
          cola_ventas[:vacia] = false


        else

          elemento = {
            ISBN: conty,
            libro: a,
            total: total,
            siguiente: nil
          }

          aux = cola_ventas[:fondo]
          aux[:siguiente] = elemento
          elemento[:siguiente] = nil

          cola[:fondo] = elemento
          cola[:tamaño] = cola[:tamaño] + 1
        end
    conty = conty +1
end

def ver_venta(cola_autores,cola_ventas)

end


def buscar_venta(cola_autores,cola_ventas)
    
end

def listado_libros(cola_autores)
    a = cola_autores[:tope]
    rows = []
    while a != nil
        b = a[:tope]
        while b != nil
            rows << [b[:isbn], b[:nombre], b[:precio], b[:existencias], a[:nombre]]
            b = b[:siguiente]
        end
        a = a[:siguiente]
    end
    table = Terminal::Table.new :rows => rows
    table.headings = ['ISBN', 'Nombre', 'Precio','Existencias', 'Autor']
    puts table
end

def listado_autores(cola_autores)
    a = cola_autores[:tope]
    rows = []
    while a != nil
        b = a[:tope]
        while b != nil
            rows << [ a[:nombre], b[:existencias]]
            b = b[:siguiente]
        end
        a = a[:siguiente]
    end
    table = Terminal::Table.new :rows => rows
    table.headings = ['Autor', 'Existencias']
    puts table
end 


conty=1
begin
    puts ''
    puts 'RUBY BOOKSTORE'
    puts '--------------'
    puts ''
    puts 'ADMINISTRACION DE LIBROS'
    puts '  1. Registro de Nuevos Libros'
    puts '  2. Registro de Autores'
    puts '  3. Listado de Libros'
    puts '  4. Listado de Autores'
    puts '  5. Buscar Libro'
    puts '  6. Buscar Autor'
    puts ''
    puts 'CONTROL DE VENTAS'
    puts '  7. Registrar una Venta'
    puts '  8. Buscar una Venta'
    puts '  9. Listado de Ventas'
    puts '  10. Salir'
    puts ''
    print 'Ingrese Opcion: '

    n = gets.to_i

    if n == 1
        registro_libros(cola_autores)
    elsif n == 2
        registro_autores(cola_autores)
    elsif n == 3
        listado_libros(cola_autores)
    elsif n == 4
       listado_autores(cola_autores)
    elsif n == 5
        ingreso_buscar_libro(cola_autores)
    elsif n == 6
        ingreso_buscar_autor(cola_autores)
    elsif n == 7
        registro_ventas(cola_autores,cola_ventas, conty)  
    elsif n == 8
        buscar_venta(cola_autores,cola_ventas)#falta
    elsif n == 9
        ver_venta(cola_autores,cola_ventas)
    elsif n == 10
        limpiar_pantalla
        puts ' -------------------'
        puts '|PROGRAMA FINALAZADO|'
        puts ' -------------------'
    else
        limpiar_pantalla
        puts ' ---------------'
        puts '|OPCION INVALIDA|'
        puts ' ---------------'
    end
end while n != 10
