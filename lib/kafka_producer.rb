class KafkaProducer
  def self.produce(topic, message, client)
    kafka = Kafka.new(['localhost:9092'], client_id: client)
    producer = kafka.producer
    producer.produce(message, topic:, partition: 0)
    begin
      producer.deliver_messages
      puts '✅ Message sent successfully!'
    rescue Kafka::DeliveryFailed => e
      puts "❌ Failed to deliver message: #{e.message}"
    end

    producer.shutdown
  end
end


##::Kafka::KafkaProducer.produce('north', 'hello parth', 'backend-partision-2')