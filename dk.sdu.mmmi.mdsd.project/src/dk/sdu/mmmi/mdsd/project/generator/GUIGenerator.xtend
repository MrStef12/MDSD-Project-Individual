package dk.sdu.mmmi.mdsd.project.generator


import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Area

class GUIGenerator {

	Resource resource;
	IFileSystemAccess2 fsa;
	IGeneratorContext context;

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		this.resource = resource
		this.fsa = fsa
		this.context = context
		
		generateArea(fsa, resource)
	}
	
	
	def void generateArea(IFileSystemAccess2 fsa, Resource resource) {
		var areas = resource.allContents.filter(Area).toList;
		
		for (Area area : areas) {
			fsa.generateFile('/src/robotdefinitionsample/' + area.name + '.fxml', generateFxmlText(area.size.x, area.size.y));
		}
		
	}
	
	def generateFxmlText(int x, int y) {
		
		// ��
		
		'''
		<?xml version="1.0" encoding="UTF-8"?>
		
		<?import java.lang.*?>
		<?import javafx.scene.control.*?>
		<?import javafx.scene.layout.*?>
		
		<AnchorPane id="AnchorPane" xmlns:fx="http://javafx.com/fxml/1" xmlns="http://javafx.com/javafx/8" fx:controller="robotdefinitionsample.FXMLDocumentController">
		   <children>
		      <GridPane gridLinesVisible="true" layoutX="14.0" layoutY="14.0" maxHeight="1.7976931348623157E308" maxWidth="1.7976931348623157E308" minHeight="-Infinity" minWidth="-Infinity" AnchorPane.bottomAnchor="14.0" AnchorPane.leftAnchor="14.0" AnchorPane.rightAnchor="14.0" AnchorPane.topAnchor="14.0">
		        <columnConstraints>
		        	«generateCol(x)»
		        </columnConstraints>
		        <rowConstraints>
		        	«generateRow(y)»
		        </rowConstraints>
		      </GridPane>
		   </children>
		</AnchorPane>
		'''
	}
	
	def generateCol(int x) {
		var result = "";
		for (var i = 0; i < x; i++) {
			result += "\n <ColumnConstraints hgrow=\"SOMETIMES\" minWidth=\"10.0\" prefWidth=\"100.0\" />"
		}
		result;
	}
	
	def generateRow(int y) {
				var result = "";
		for (var i = 0; i < y; i++) {
			result += "\n <RowConstraints minHeight=\"10.0\" prefHeight=\"30.0\" vgrow=\"SOMETIMES\" />"
		}
		result;
	}
}