this.arena_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {
		UIImageClosed = null,
		CooldownUntil = 0
	},
	function refreshCooldown()
	{
		this.m.CooldownUntil = this.World.getTime().Days + 1;
	}

	function isClosed()
	{
		return this.World.getTime().Days < this.m.CooldownUntil;
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.arena";
		this.m.Name = "Arena";
		this.m.UIImage = "ui/settlements/desert_building_05";
		this.m.UIImageNight = "ui/settlements/desert_building_05_night";
		this.m.UIImageClosed = "ui/settlements/desert_building_05_closed";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Arena";
		this.m.TooltipIcon = "ui/icons/buildings/arena.png";
		this.m.Sounds = [
			{
				File = "ambience/buildings/arena_01.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/arena_02.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/arena_03.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/arena_04.wav",
				Volume = 0.75,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [];
	}

	function getUIImage()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return this.m.UIImageNight;
		}

		if (this.World.getTime().Days >= this.m.CooldownUntil)
		{
			return this.m.UIImage;
		}
		else
		{
			return this.m.UIImageClosed;
		}
	}

	function onClicked( _townScreen )
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if ((this.World.Contracts.getActiveContract() == null || this.World.Contracts.getActiveContract().getType() == "contract.arena" || this.World.Contracts.getActiveContract().getType() == "contract.arena_tournament") && this.World.getTime().Days >= this.m.CooldownUntil)
		{
			local f = this.World.FactionManager.getFactionOfType(this.Const.Faction.Arena);
			local contracts = f.getContracts();
			local c;

			if (this.World.Contracts.getActiveContract() != null && (this.World.Contracts.getActiveContract().getType() == "contract.arena" || this.World.Contracts.getActiveContract().getType() == "contract.arena_tournament"))
			{
				c = this.World.Contracts.getActiveContract();
			}
			else if (contracts.len() == 0)
			{
				if (this.World.State.getCurrentTown().hasSituation("situation.arena_tournament") && this.World.Assets.getStash().getNumberOfEmptySlots() >= 5)
				{
					c = this.new("scripts/contracts/contracts/arena_tournament_contract");
					c.setFaction(f.getID());
					c.setHome(this.World.State.getCurrentTown());
					this.World.Contracts.addContract(c);
				}
				else if (this.World.Assets.getStash().getNumberOfEmptySlots() >= 3)
				{
					c = this.new("scripts/contracts/contracts/arena_contract");
					c.setFaction(f.getID());
					c.setHome(this.World.State.getCurrentTown());
					this.World.Contracts.addContract(c);
				}
				else
				{
					return;
				}
			}
			else
			{
				c = contracts[0];
			}

			c.setScreenForArena();
			this.World.Contracts.showContract(c);
		}
	}

	function onSettlementEntered()
	{
	}

	function onUpdateDraftList( _list )
	{
		_list.push("gladiator_background");
		_list.push("gladiator_background");
		_list.push("gladiator_background");
		_list.push("gladiator_background");
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
		_out.writeU32(this.m.CooldownUntil);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 56)
		{
			this.m.CooldownUntil = _in.readU32();
		}
	}

});

