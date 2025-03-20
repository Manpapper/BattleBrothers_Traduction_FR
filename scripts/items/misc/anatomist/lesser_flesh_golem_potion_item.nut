this.lesser_flesh_golem_potion_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.lesser_flesh_golem_potion";
		this.m.Name = "Potion of Change";
		this.m.Description = "This vile tasting concoction, distilled from the remains of a flesh golem, promises to cure joint pain, grow muscle mass, and even sharpen vision! Results not guaranteed.";
		this.m.IconLarge = "";
		this.m.Icon = "consumables/potion_42.png";
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Gain a random positive trait"
		});
		result.push({
			id = 65,
			type = "text",
			text = "Right-click or drag onto the currently selected character in order to drink. This item will be consumed in the process."
		});
		result.push({
			id = 65,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Mutates the body, causing sickness"
		});
		return result;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
	}

	function onUse( _actor, _item = null )
	{
		local applicableTraits = [
			"scripts/skills/traits/athletic_trait",
			"scripts/skills/traits/brave_trait",
			"scripts/skills/traits/bright_trait",
			"scripts/skills/traits/deathwish_trait",
			"scripts/skills/traits/dexterous_trait",
			"scripts/skills/traits/eagle_eyes_trait",
			"scripts/skills/traits/fearless_trait",
			"scripts/skills/traits/hate_beasts_trait",
			"scripts/skills/traits/hate_greenskins_trait",
			"scripts/skills/traits/hate_undead_trait",
			"scripts/skills/traits/iron_lungs_trait",
			"scripts/skills/traits/iron_jaw_trait",
			"scripts/skills/traits/loyal_trait",
			"scripts/skills/traits/lucky_trait",
			"scripts/skills/traits/night_owl_trait",
			"scripts/skills/traits/optimist_trait",
			"scripts/skills/traits/quick_trait",
			"scripts/skills/traits/strong_trait",
			"scripts/skills/traits/sure_footing_trait",
			"scripts/skills/traits/survivor_trait",
			"scripts/skills/traits/swift_trait",
			"scripts/skills/traits/teamplayer_trait",
			"scripts/skills/traits/tough_trait"
		];
		local traitsToAdd = 1;

		while (traitsToAdd > 0 && applicableTraits.len() > 0)
		{
			local trait = this.new(applicableTraits.remove(this.Math.rand(0, applicableTraits.len() - 1)));

			if (!_actor.getSkills().hasSkill(trait.getID()))
			{
				_actor.getSkills().add(trait);
				traitsToAdd = traitsToAdd - 1;
			}
		}

		_actor.getSkills().add(this.new("scripts/skills/effects/lesser_flesh_golem_potion_effect"));
		return this.anatomist_potion_item.onUse(_actor, _item);
	}

});

