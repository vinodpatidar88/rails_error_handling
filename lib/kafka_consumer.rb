class KafkaConsumer
  def self.consume(topic)
    kafka = Kafka.new(['localhost:9092'], client_id: 'backend-kafka-1')

    kafka.each_message(topic:) do |message|
      puts "Received message: #{message.value}"
    end
  end
end


##::Kafka::KafkaConsumer.consume('vinodpatidar')
