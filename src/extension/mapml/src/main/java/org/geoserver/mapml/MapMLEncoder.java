/* (c) 2023 Open Source Geospatial Foundation - all rights reserved
 * This code is licensed under the GPL 2.0 license, available at the root
 * application directory.
 */
package org.geoserver.mapml;

import java.io.OutputStream;
import java.io.Reader;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.namespace.NamespaceContext;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;
import org.geoserver.mapml.xml.Mapml;
import org.geoserver.platform.ServiceException;

/** Encodes a MapML object onto an output stream */
public class MapMLEncoder {
    private final JAXBContext context;

    /**
     * Constructor
     *
     * @throws JAXBException if there is a problem creating the JAXBContext
     */
    public MapMLEncoder() throws JAXBException {
        // this creation is expensive, do it once and cache it
        context = JAXBContext.newInstance(Mapml.class);
    }

    /**
     * Create a Marshaller
     *
     * @return Marshaller
     * @throws JAXBException if there is a problem creating the Marshaller
     */
    private Marshaller createMarshaller() throws JAXBException {
        Marshaller m = context.createMarshaller();
        m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        m.setProperty(Marshaller.JAXB_FRAGMENT, true);
        return m;
    }

    /**
     * Use Marshaller to encode MapML object onto an output stream
     *
     * @param mapml MapML object
     * @param output OutputStream
     */
    public void encode(Mapml mapml, OutputStream output) {
        try {
            XMLStreamWriter writer =
                    new Wrapper(XMLOutputFactory.newInstance().createXMLStreamWriter(output));
            createMarshaller().marshal(mapml, writer);
            writer.flush();
        } catch (JAXBException | XMLStreamException e) {
            throw new ServiceException(e);
        }
    }

    /**
     * Use Unmarshaller to decode MapML object from a Reader
     *
     * @param reader Reader
     * @return MapML object
     */
    public Mapml decode(Reader reader) {
        try {
            Unmarshaller unmarshaller = context.createUnmarshaller();
            return (Mapml) unmarshaller.unmarshal(reader);
        } catch (JAXBException e) {
            throw new ServiceException(e);
        }
    }

    /**
     * Wrapper class to provide control over namespace prefixing even if XML implementation classes
     * are regenerated
     */
    static class Wrapper implements XMLStreamWriter {

        private final XMLStreamWriter writer;
        private static final String NS_PREFIX = "";

        /**
         * Constructor
         *
         * @param writer XMLStreamWriter
         */
        Wrapper(XMLStreamWriter writer) {
            this.writer = writer;
        }

        @Override
        public void writeStartElement(String localName) throws XMLStreamException {
            writer.writeStartElement(localName);
        }

        @Override
        public void writeStartElement(String namespaceURI, String localName)
                throws XMLStreamException {
            writer.writeStartElement(namespaceURI, localName);
        }

        @Override
        public void writeStartElement(String prefix, String localName, String namespaceURI)
                throws XMLStreamException {
            writer.writeStartElement(NS_PREFIX, localName, namespaceURI);
        }

        @Override
        public void writeEmptyElement(String namespaceURI, String localName)
                throws XMLStreamException {
            writer.writeEmptyElement(namespaceURI, localName);
        }

        @Override
        public void writeEmptyElement(String prefix, String localName, String namespaceURI)
                throws XMLStreamException {
            writer.writeEmptyElement(prefix, localName, namespaceURI);
        }

        @Override
        public void writeEmptyElement(String localName) throws XMLStreamException {
            writer.writeEmptyElement(localName);
        }

        @Override
        public void writeEndElement() throws XMLStreamException {
            writer.writeEndElement();
        }

        @Override
        public void writeEndDocument() throws XMLStreamException {
            writer.writeEndDocument();
        }

        @Override
        public void close() throws XMLStreamException {
            writer.close();
        }

        @Override
        public void flush() throws XMLStreamException {
            writer.flush();
        }

        @Override
        public void writeAttribute(String localName, String value) throws XMLStreamException {
            writer.writeAttribute(localName, value);
        }

        @Override
        public void writeAttribute(
                String prefix, String namespaceURI, String localName, String value)
                throws XMLStreamException {
            writer.writeAttribute(prefix, namespaceURI, localName, value);
        }

        @Override
        public void writeAttribute(String namespaceURI, String localName, String value)
                throws XMLStreamException {
            writer.writeAttribute(namespaceURI, localName, value);
        }

        @Override
        public void writeNamespace(String prefix, String namespaceURI) throws XMLStreamException {
            writer.writeNamespace(NS_PREFIX, namespaceURI);
        }

        @Override
        public void writeDefaultNamespace(String namespaceURI) throws XMLStreamException {
            writer.writeDefaultNamespace(namespaceURI);
        }

        @Override
        public void writeComment(String data) throws XMLStreamException {
            writer.writeComment(data);
        }

        @Override
        public void writeProcessingInstruction(String target) throws XMLStreamException {
            writer.writeProcessingInstruction(target);
        }

        @Override
        public void writeProcessingInstruction(String target, String data)
                throws XMLStreamException {
            writer.writeProcessingInstruction(target, data);
        }

        @Override
        public void writeCData(String data) throws XMLStreamException {
            writer.writeCData(data);
        }

        @Override
        public void writeDTD(String dtd) throws XMLStreamException {
            writer.writeDTD(dtd);
        }

        @Override
        public void writeEntityRef(String name) throws XMLStreamException {
            writer.writeEntityRef(name);
        }

        @Override
        public void writeStartDocument() throws XMLStreamException {
            writer.writeStartDocument();
        }

        @Override
        public void writeStartDocument(String version) throws XMLStreamException {
            writer.writeStartDocument(version);
        }

        @Override
        public void writeStartDocument(String encoding, String version) throws XMLStreamException {
            writer.writeStartDocument(encoding, version);
        }

        @Override
        public void writeCharacters(String text) throws XMLStreamException {
            writer.writeCharacters(text);
        }

        @Override
        public void writeCharacters(char[] text, int start, int len) throws XMLStreamException {
            writer.writeCharacters(text, start, len);
        }

        @Override
        public String getPrefix(String uri) throws XMLStreamException {
            return writer.getPrefix(uri);
        }

        @Override
        public void setPrefix(String prefix, String uri) throws XMLStreamException {
            writer.setPrefix(prefix, uri);
        }

        @Override
        public void setDefaultNamespace(String uri) throws XMLStreamException {
            writer.setDefaultNamespace(uri);
        }

        @Override
        public void setNamespaceContext(NamespaceContext context) throws XMLStreamException {
            writer.setNamespaceContext(context);
        }

        @Override
        public NamespaceContext getNamespaceContext() {
            return writer.getNamespaceContext();
        }

        @Override
        public Object getProperty(String name) throws IllegalArgumentException {
            return writer.getProperty(name);
        }
    }
}
