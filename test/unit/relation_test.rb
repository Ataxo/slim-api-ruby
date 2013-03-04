# -*- encoding : utf-8 -*-
require './test/test_helper'
class RelationTest < Test::Unit::TestCase    

  context "Relation" do

    should "find all" do
      assert relation = SlimApi::Relation.find(), "Should not be nil"
      assert relation.is_a?(Array), "Should be array"
    end

    should "create one" do
      SlimApi::Relation.where(:campaign_id => "333").includes(:id).each do |relation|
        relation.destroy!
      end
      relation = SlimApi::Relation.new(:campaign_id => 333, system: 'adwords', system_campaign_id: "11232")
      assert relation.save, "Errors: #{relation.errors}"
    end

    should "create one with errors" do
      relation = SlimApi::Relation.new()
      refute relation.save, "should not be saved"
      assert relation.errors.to_hash.is_a?(Hash), "errors should be a Hash"
    end

    context "query interface - Retrieving a Single Object" do
      setup do
        SlimApi::Relation.where(:campaign_id => "333").each do |relation|
          relation.destroy!
        end

        #create object!
        @relation = SlimApi::Relation.new(:campaign_id => 333, system: 'adwords', system_campaign_id: "11232", :status => 'running')
        @relation.save
        @relation2 = SlimApi::Relation.new(:campaign_id => 333, system: 'adwords', system_campaign_id: "11233", :status => 'stopped')
        @relation2.save

      end

      should "have query interface" do
        assert SlimApi::Relation.query.is_a?(SlimApi::SlimQuery)
      end

      should "return every relation" do
        all_relations = SlimApi::Relation.where(:campaign_id => 333)
        assert_equal all_relations.size, 2, "should have two relations"
      end

      should "return every not stopped relations" do
        all_relations = SlimApi::Relation.where(:campaign_id => 333).where(:'status.not_eq' => 'stopped')
        assert_equal all_relations.size, 1, "should have one relation"
      end

      should "have different updated at on resaving same date" do
        puts "sleeping 2 seconds to change updated at"
        sleep(2)
        relation = SlimApi::Relation.new(:campaign_id => 333, system: 'adwords', system_campaign_id: "11232", :status => 'paused')
        relation.save
        relation = SlimApi::Relation.find(@relation.id)
        assert_equal relation.status, 'paused'
        assert relation.created_at < relation.updated_at
      end
    end

  end
end
