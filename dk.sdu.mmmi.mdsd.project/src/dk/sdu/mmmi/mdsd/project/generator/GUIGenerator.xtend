package dk.sdu.mmmi.mdsd.project.generator


import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.project.dSL.Area

class GUIGenerator {

	new (Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		var area = resource.allContents.filter(Area).next;
		fsa.generateFile('/src/robotdefinitionsample/FXMLDocument.fxml', area.generateFxmlText);
	}
	
	def generateFxmlText(Area area) {
		
		'''
		<?xml version="1.0" encoding="UTF-8"?>
		
		<?import java.lang.*?>
		<?import javafx.scene.control.*?>
		<?import javafx.scene.layout.*?>
		
		<AnchorPane id="AnchorPane" prefHeight="750.0" prefWidth="1000.0" xmlns="http://javafx.com/javafx/8" xmlns:fx="http://javafx.com/fxml/1" fx:controller="robotdefinitionsample.FXMLDocumentController">
		   <children>
		      <GridPane fx:id="grid" gridLinesVisible="true" layoutX="14.0" layoutY="14.0" maxHeight="1.7976931348623157E308" maxWidth="1.7976931348623157E308" minHeight="-Infinity" minWidth="-Infinity" AnchorPane.bottomAnchor="14.0" AnchorPane.leftAnchor="14.0" AnchorPane.rightAnchor="14.0" AnchorPane.topAnchor="50.0">
		        <columnConstraints>
		        	«area.size.x.generateCol»
		        </columnConstraints>
		        <rowConstraints>
		        	«area.size.y.generateRow»
		        </rowConstraints>
		      </GridPane>
		      <Button fx:id="Tick" layoutX="14.0" layoutY="14.0" mnemonicParsing="false" onAction="#onClick" text="Tick" />
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