require "rails_helper"

RSpec.describe SendMailJob, type: :job do

  include ActiveJob::TestHelper
  fixtures :orders
  fixtures :users

  subject(:job) { described_class.perform_later(1) }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in urgent queue' do
    expect(SendMailJob.new.queue_name).to eq('default')
  end

  it 'handles no results error' do
    order = orders(:order_one)
    allow(UserMailer).to receive(:order_email).and_raise(StandardError)
    perform_enqueued_jobs do
      expect_any_instance_of(SendMailJob)
        .to receive(:retry_job).with(wait: 300, queue: :default, priority: nil)

      job
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
