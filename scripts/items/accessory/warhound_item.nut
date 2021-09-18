this.warhound_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		Skill = null,
		Entity = null,
		Script = "scripts/entity/tactical/warhound",
		ArmorScript = null,
		UnleashSounds = [
			"sounds/combat/unleash_wardog_01.wav",
			"sounds/combat/unleash_wardog_02.wav",
			"sounds/combat/unleash_wardog_03.wav",
			"sounds/combat/unleash_wardog_04.wav"
		]
	},
	function isAllowedInBag()
	{
		return false;
	}

	function getScript()
	{
		return this.m.Script;
	}

	function getArmorScript()
	{
		return this.m.ArmorScript;
	}

	function isUnleashed()
	{
		return this.m.Entity != null;
	}

	function getName()
	{
		if (this.m.Entity == null)
		{
			return this.item.getName();
		}
		else
		{
			return "Warhound Collar";
		}
	}

	function setName( _n )
	{
		this.m.Name = _n;
	}

	function getDescription()
	{
		if (this.m.Entity == null)
		{
			return this.item.getDescription();
		}
		else
		{
			return "The collar of a warhound that has been unleashed onto the battlefield.";
		}
	}

	function create()
	{
		this.accessory.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "accessory.warhound";
		this.m.Name = this.Const.Strings.WardogNames[this.Math.rand(0, this.Const.Strings.WardogNames.len() - 1)] + " the Warhound";
		this.m.Description = "A strong and loyal northern hound bred for war. Can be unleashed in battle for scouting, tracking or running down routing enemies.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = false;
		this.m.IsChangeableInBattle = false;
		this.m.Value = 250;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/inventory/wardog_inventory_0" + this.Math.rand(1, 3) + ".wav", this.Const.Sound.Volume.Inventory);
	}

	function updateVariant()
	{
		this.setEntity(this.m.Entity);
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;

		if (this.m.Entity != null)
		{
			this.m.Icon = "tools/hound_01_leash_70x70.png";
		}
		else
		{
			this.m.Icon = "tools/hound_0" + this.m.Variant + "_70x70.png";
		}
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local unleash = this.new("scripts/skills/actives/unleash_wardog");
		unleash.setItem(this);
		unleash.m.Name = "Unleash Warhound";
		unleash.m.Description = "Unleash your warhound and send him charging into the enemy. Needs a free tile adjacent.";
		unleash.m.Icon = "skills/active_165.png";
		unleash.m.IconDisabled = "skills/active_165_sw.png";
		unleash.m.Overlay = "active_165";
		this.m.Skill = this.WeakTableRef(unleash);
		this.addSkill(unleash);
	}

	function onCombatFinished()
	{
		this.setEntity(null);
	}

	function onActorDied( _onTile )
	{
		if (!this.isUnleashed() && _onTile != null)
		{
			local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);
			entity.setItem(this);
			entity.setName(this.getName());
			entity.setVariant(this.getVariant());
			this.setEntity(entity);
			entity.setFaction(this.Const.Faction.PlayerAnimals);

			if (this.m.ArmorScript != null)
			{
				local item = this.new(this.m.ArmorScript);
				entity.getItems().equip(item);
			}

			this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
		}
	}

	function onCombatFinished()
	{
		this.setEntity(null);
	}

	function onSerialize( _out )
	{
		this.accessory.onSerialize(_out);
		_out.writeString(this.m.Name);
	}

	function onDeserialize( _in )
	{
		this.accessory.onDeserialize(_in);
		this.m.Name = _in.readString();
	}

});

