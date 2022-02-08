/*ESQUEMA RELACIONAL:
centros(+numcentro, nomcentro, direccion)
deptos(+[numcentro*,numdepto], presupuesto, nomdepto, [deptodepen, centrodepen]*)
empleados(+numempleado, [numcentro, numdepto]*, extelefon, fecnacim, fecingreo, salario, comision, numhijos, nomemp)
dirigir(+[numempleado*, (numcentro, numdepto)*, fecinidir], fecfindir)
*/

create database if not exists actividad1;
use actividad1;

create table if not exists centros
(
	numcentro int not null,
    nomcentro varchar(40),
    direccion varchar(100),
    
    constraint pk_centros primary key (numcentro)
);

create table if not exists departamentos
(
	numcentro int not null,
    numdepto int not null,
    presupuesto decimal(10,2),
    nomdepto varchar(40),
    centrodepen int,
    deptodepen int,
    
    -- decimal(10,2) = 10 cifras de las cuales 2 son decimales
    
    constraint pk_departamentos primary key (numcentro,numdepto),
    constraint fk_departamentos_centros foreign key (numcentro)
			references centros (numcentro)
				on delete no action on update cascade,
    constraint fk_departamentos_departamentos foreign key (centrodepen,deptodepen)
			references departamentos (numcentro,numdepto)
				on delete no action on update cascade
);

create table if not exists empleados
(
	numempleado int not null,
    numcentro int,
    numdepto int,
    extelefon char(3),
    fecnacim date not null, 
    fecingreo date not null, 
    salario decimal(10,2), 
    comision decimal(10,2),
    numhijos tinyint unsigned default '0', 
    nomemp varchar(20),
    ap1emp varchar(20),
    ap2emp varchar(20),
    
    -- tinyint = int(1) Es 1 byte, -128 - 127
    -- Si es unsigned, 0 - 255, ya que utiliza los negativos

    constraint pk_empleados primary key (numempleado),
    constraint fk_empleados_departamentos foreign key (numcentro, numdepto)
			references departamentos (numcentro,numdepto)
				on delete no action on update cascade
);

create table if not exists dirigir
(
	numempleado int,
    numcentro int,
    numdepto int, 
    fecinidir date, 
    fecfindir date,
    
    constraint pk_dirigir primary key (numempleado,numcentro,numdepto,fecinidir),
    constraint fk_dirigir_empleados foreign key (numempleado)
			references empleados (numempleado)
				on delete no action on update cascade,
    constraint fk_dirigir_departamentos foreign key (numcentro,numdepto)
			references departamentos (numcentro,numdepto)
				on delete no action on update cascade
);

/*ALTER TABLE nombredetabla
	add column dfdsf
    add column sgsdg
    add constraint ...*/
    
    /*Para la BD correspondiente al ejercicio 1 de la Unidad 5
    (empleados, deptos, centros de trabajo y directores de 
    departamento), da de alta los registros correspondientes a 
    los centros de trabajo, departamentos y los primeros 10 
    empleados que aparecen en el documento anexo.*/
 
 insert into centros
	(numcentro, nomcentro, direccion)
 values
	(10,'SEDE CENTRAL','C.ALCALA, 820, MADRID'),
    (20,'RELACION CON CLIENTES','C.ATOCHA, 405, MADRID');
    
 insert into departamentos
	(numcentro, numdepto, presupuesto, nomdepto, centrodepen, deptodepen)
 values
	(10, 100, 129000, 'DIRECCION GENERAL', null, null),
    (20, 110, 100000, 'DIRECC.COMERCIAL', 10, 100),
    (20, 111, 90000, 'SECTOR INDUSTRIAL', 20, 110),
    (20, 112, 175000, 'SECTOR SERVICIOS', 20, 110),
    (10, 120, 50000, 'ORGANIZACION', 10, 100),
    (10, 121, 74000, 'PERSONAL', 10, 120),
    (10, 122, 68000, 'PROCESO DE DATOS', 10, 120),
    (10, 130, 85000, 'FINANZAS', 10, 100);
    
insert into empleados
    (numempleado, numcentro, numdepto, extelefon, fecnacim, fecingreo,
    salario, comision, numhijos, nomemp, ap1emp, ap2emp)
values
	()
	
	
	
	
	
	
	
	
	
	
	
	
	public String modificarCodBandeja() {
        
        String codigoNuevo = null;
       
        do {
            try { //Controla el botón cancelar
                bucle = true;
                String str = JOptionPane.showInputDialog("El código de la Bandeja es " + this.codigoBandeja
                        + "\nIntroduzca un nuevo código. (En blanco = Salir)");
                if (str.length() == 3) { //Comprueba que el código tenga 3 caracteres
                    codigoNuevo = str;
                    bucle = false;
                } else if (str.equalsIgnoreCase("")) {
                    bucle = false;
                } else {

                    JOptionPane.showMessageDialog(null, "Formato no válido. Por favor, inténtelo de nuevo.");
                }

            } catch (NullPointerException npe) {

                bucle = false;
            }
        } while (bucle);
        
        return codigoNuevo;
    }



String nuevoCodigo = maquina.getBandeja1().modificarCodBandeja();                                     maquina.getBandeja1().modificarCodBandeja();
                                        
                                        if (!nuevoCodigo.equalsIgnoreCase(maquina.getBandeja2().getCodigoBandeja())) {
                                            
                                            maquina.getBandeja1().setCodigoBandeja(nuevoCodigo);
                                            
                                        }

