this.tavern_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {
		RumorsGiven = 0,
		RoundsGiven = 0,
		LastRumorTime = 0.0,
		LastRoundTime = 0.0,
		LastRumor = "",
		ContractSettlement = null,
		Location = null
	},
	function create()
	{
		this.building.create();
		this.m.ID = "building.tavern";
		this.m.Name = "Tavern";
		this.m.UIImage = "ui/settlements/building_02";
		this.m.UIImageNight = "ui/settlements/building_02_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Tavern";
		this.m.TooltipIcon = "ui/icons/buildings/tavern.png";
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [
			{
				File = "ambience/buildings/tavern_laugh_00.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_01.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_02.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_03.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_04.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_05.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_06.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_08.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_09.wav",
				Volume = 0.75,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [
			{
				File = "ambience/buildings/tavern_laugh_00.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_01.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_02.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_03.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_04.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_05.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_06.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_08.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_09.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_drunk_00.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_drunk_01.wav",
				Volume = 0.5,
				Pitch = 1.0
			}
		];
	}

	function buildText( _text )
	{
		local villages = this.World.EntityManager.getSettlements();
		local towns = [];

		foreach( v in villages )
		{
			if (!v.isSouthern())
			{
				towns.push(v);
			}
		}

		local distance = this.m.Location != null && !this.m.Location.isNull() ? this.m.Settlement.getTile().getDistanceTo(this.m.Location.getTile()) : 0;
		distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
		local mercCompany = this.World.EntityManager.getMercenaries().len() != 0 ? this.World.EntityManager.getMercenaries()[this.Math.rand(0, this.World.EntityManager.getMercenaries().len() - 1)].getName() : this.Const.Strings.MercenaryCompanyNames[this.Math.rand(0, this.Const.Strings.MercenaryCompanyNames.len() - 1)];
		local text;
		local vars = [
			[
				"SPEECH_ON",
				"\n\n[color=#bcad8c]\""
			],
			[
				"SPEECH_OFF",
				"\"[/color]\n\n"
			],
			[
				"companyname",
				this.World.Assets.getName()
			],
			[
				"townname",
				this.m.Settlement.getName()
			],
			[
				"settlement",
				this.m.ContractSettlement != null && !this.m.ContractSettlement.isNull() ? this.m.ContractSettlement.getName() : ""
			],
			[
				"location",
				this.m.Location != null && !this.m.Location.isNull() ? this.m.Location.getName() : ""
			],
			[
				"direction",
				this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Direction8[this.m.Settlement.getTile().getDirection8To(this.m.Location.getTile())] : ""
			],
			[
				"terrain",
				this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Terrain[this.m.Location.getTile().Type] : ""
			],
			[
				"distance",
				distance
			],
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomfemalename",
				this.Const.Strings.CharacterNamesFemale[this.Math.rand(0, this.Const.Strings.CharacterNamesFemale.len() - 1)]
			],
			[
				"randomnoble",
				this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]
			],
			[
				"randomtown",
				towns[this.Math.rand(0, towns.len() - 1)].getNameOnly()
			],
			[
				"randommercenarycompany",
				mercCompany
			],
			[
				"item",
				this.m.Location != null && !this.m.Location.isNull() && !this.m.Location.getLoot().isEmpty() ? this.m.Location.getLoot().getItems()[0].getName() : ""
			],
			[
				"region",
				""
			]
		];
		return this.buildTextFromTemplate(_text, vars);
	}

	function onClicked( _townScreen )
	{
		_townScreen.getTavernDialogModule().setTavern(this);
		_townScreen.showTavernDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
		if (this.Time.getVirtualTimeF() - this.m.LastRumorTime > this.World.getTime().SecondsPerDay)
		{
			this.m.RumorsGiven = 0;
			this.m.LastRumor = "";
			this.m.ContractSettlement = null;
			this.m.Location = null;
		}

		if (this.Time.getVirtualTimeF() - this.m.LastRoundTime > this.World.getTime().SecondsPerDay)
		{
			this.m.RoundsGiven = 0;
		}

		if (this.m.Location == null || this.m.Location.isNull() || !this.m.Location.isAlive())
		{
			this.m.Location = null;
		}

		if (this.m.ContractSettlement == null || this.m.ContractSettlement.isNull() || !this.m.ContractSettlement.isAlive())
		{
			this.m.ContractSettlement = null;
		}
	}

	function getRumorPrice()
	{
		return this.Math.round(20 * this.m.Settlement.getBuyPriceMult());
	}

	function getRumor( _isPaidFor = false )
	{
		if (_isPaidFor)
		{
			if (this.World.Assets.getMoney() < this.Math.round(20 * this.m.Settlement.getBuyPriceMult()))
			{
				return null;
			}

			this.World.Assets.addMoney(this.Math.round(-20 * this.m.Settlement.getBuyPriceMult()));
			++this.m.RumorsGiven;
			this.Sound.play(this.Const.Sound.TavernRumor[this.Math.rand(0, this.Const.Sound.TavernRumor.len() - 1)]);
		}

		if (this.m.RumorsGiven > 3)
		{
			if (_isPaidFor)
			{
				return "The patrons raise their cups to you, but it seems there is nothing more to be learned by talking to them tonight.";
			}
			else
			{
				return "The patrons talk about this and that.";
			}
		}
		else
		{
			this.m.LastRumorTime = this.Time.getVirtualTimeF();
			local rumor = "";

			if (_isPaidFor)
			{
				if (!this.m.Settlement.isMilitary())
				{
					this.World.FactionManager.getFaction(this.m.Settlement.getFactions()[0]).addPlayerRelation(0.1);
				}

				rumor = rumor + this.Const.Strings.PayTavernRumorsIntro[this.Math.rand(0, this.Const.Strings.PayTavernRumorsIntro.len() - 1)];
			}
			else if (this.m.LastRumor != "")
			{
				return this.m.LastRumor;
			}
			else
			{
				rumor = rumor + "The patrons talk about this and that.";
			}

			local candidates = [];
			local r = this.World.Assets.m.IsNonFlavorRumorsOnly ? this.Math.rand(3, 6) : this.Math.rand(1, 6);

			if (r <= 2)
			{
				if (this.World.FactionManager.isGreaterEvil())
				{
					candidates.extend(this.Const.Strings.RumorsGreaterEvil[this.World.FactionManager.getGreaterEvilType()]);
					candidates.extend(this.Const.Strings.RumorsGreaterEvil[this.World.FactionManager.getGreaterEvilType()]);
				}
				else
				{
					candidates.extend(this.Const.Strings.RumorsGeneral);
				}

				if (this.m.Settlement.isMilitary())
				{
					candidates.extend(this.Const.Strings.RumorsMilitary);
				}
				else
				{
					candidates.extend(this.Const.Strings.RumorsCivilian);
				}

				candidates.extend(this.m.Settlement.getRumors());
			}
			else if (r == 3)
			{
				local best;
				local bestDist = 9000;

				foreach( s in this.World.EntityManager.getSettlements() )
				{
					if (s.isMilitary() || s.getID() == this.m.Settlement.getID())
					{
						continue;
					}

					if (this.World.FactionManager.getFaction(s.getFactions()[0]).getContracts().len() != 0)
					{
						local d = s.getTile().getDistanceTo(this.m.Settlement.getTile());

						if (d < bestDist)
						{
							bestDist = d;
							best = s;
						}
					}

					if (best != null)
					{
						candidates.extend(this.Const.Strings.RumorsContract);
						this.m.ContractSettlement = this.WeakTableRef(best);
					}
					else
					{
						candidates.extend(this.Const.Strings.RumorsGeneral);

						if (this.m.Settlement.isMilitary())
						{
							candidates.extend(this.Const.Strings.RumorsMilitary);
						}
						else
						{
							candidates.extend(this.Const.Strings.RumorsCivilian);
						}

						candidates.extend(this.m.Settlement.getRumors());
					}
				}
			}
			else if (r == 4)
			{
				local best;
				local bestDist = 9000;

				foreach( s in this.World.EntityManager.getLocations() )
				{
					if (s.isLocationType(this.Const.World.LocationType.AttachedLocation) || s.isLocationType(this.Const.World.LocationType.Unique) || s.isAlliedWithPlayer())
					{
						continue;
					}

					local d = s.getTile().getDistanceTo(this.m.Settlement.getTile()) - this.Math.rand(1, 10);

					if (d < bestDist)
					{
						bestDist = d;
						best = s;
					}
				}

				if (best != null)
				{
					candidates.extend(this.Const.Strings.RumorsLocation);
					this.m.Location = this.WeakTableRef(best);
				}
				else
				{
					candidates.extend(this.Const.Strings.RumorsGeneral);

					if (this.m.Settlement.isMilitary())
					{
						candidates.extend(this.Const.Strings.RumorsMilitary);
					}
					else
					{
						candidates.extend(this.Const.Strings.RumorsCivilian);
					}

					candidates.extend(this.m.Settlement.getRumors());
				}
			}
			else if (r == 5)
			{
				local best;
				local bestDist = 9000;

				foreach( s in this.World.EntityManager.getLocations() )
				{
					if (s.isAlliedWithPlayer())
					{
						continue;
					}

					if (s.getLoot().isEmpty())
					{
						continue;
					}

					local d = s.getTile().getDistanceTo(this.m.Settlement.getTile()) - this.Math.rand(1, 10);

					if (d > 20)
					{
						continue;
					}

					if (d < bestDist)
					{
						bestDist = d;
						best = s;
					}
				}

				if (best != null)
				{
					local f = this.World.FactionManager.getFaction(best.getFaction());
					local category = 0;

					if (best.getLoot().getItems()[0].isItemType(this.Const.Items.ItemType.Shield))
					{
						category = 1;
					}
					else if (best.getLoot().getItems()[0].isItemType(this.Const.Items.ItemType.Armor) || best.getLoot().getItems()[0].isItemType(this.Const.Items.ItemType.Helmet))
					{
						category = 2;
					}

					if (f.getType() == this.Const.FactionType.Orcs)
					{
						candidates.extend(this.Const.Strings.RumorsItemsOrcs[category]);
					}
					else if (f.getType() == this.Const.FactionType.Goblins)
					{
						candidates.extend(this.Const.Strings.RumorsItemsGoblins[category]);
					}
					else if (f.getType() == this.Const.FactionType.Undead || f.getType() == this.Const.FactionType.Zombies)
					{
						candidates.extend(this.Const.Strings.RumorsItemsUndead[category]);
					}
					else if (f.getType() == this.Const.FactionType.Barbarians)
					{
						candidates.extend(this.Const.Strings.RumorsItemsBarbarians[category]);
					}
					else if (f.getType() == this.Const.FactionType.OrientalBandits)
					{
						candidates.extend(this.Const.Strings.RumorsItemsNomads[category]);
					}
					else
					{
						candidates.extend(this.Const.Strings.RumorsItemsBandits[category]);
					}

					this.m.Location = this.WeakTableRef(best);
				}
				else
				{
					candidates.extend(this.Const.Strings.RumorsGeneral);

					if (this.m.Settlement.isMilitary())
					{
						candidates.extend(this.Const.Strings.RumorsMilitary);
					}
					else
					{
						candidates.extend(this.Const.Strings.RumorsCivilian);
					}

					candidates.extend(this.m.Settlement.getRumors());
				}
			}
			else if (r == 6)
			{
				local best;
				local bestDist = 9000;

				foreach( s in this.World.EntityManager.getSettlements() )
				{
					if (s.getID() == this.m.Settlement.getID())
					{
						continue;
					}

					s.updateSituations();

					if (s.getSituations().len() > 0)
					{
						local d = s.getTile().getDistanceTo(this.m.Settlement.getTile());

						if (d < bestDist)
						{
							bestDist = d;
							best = s;
						}
					}
				}

				if (best != null)
				{
					local situation = best.getSituations()[this.Math.rand(0, best.getSituations().len() - 1)];
					candidates.extend(situation.getRumors());
					this.m.ContractSettlement = this.WeakTableRef(best);
				}
				else
				{
					candidates.extend(this.Const.Strings.RumorsGeneral);

					if (this.m.Settlement.isMilitary())
					{
						candidates.extend(this.Const.Strings.RumorsMilitary);
					}
					else
					{
						candidates.extend(this.Const.Strings.RumorsCivilian);
					}

					candidates.extend(this.m.Settlement.getRumors());
				}
			}

			rumor = rumor + "\n\n[color=#bcad8c]\"";
			rumor = rumor + candidates[this.Math.rand(0, candidates.len() - 1)];
			rumor = rumor + "\"[/color]\n\n";
			rumor = this.buildText(rumor);
			this.m.LastRumor = rumor;
			return rumor;
		}
	}

	function getDrinkPrice()
	{
		return this.Math.round(this.World.getPlayerRoster().getSize() * 5 * this.m.Settlement.getBuyPriceMult());
	}

	function getDrinkResult()
	{
		local bros = this.World.getPlayerRoster().getAll();

		if (this.World.Assets.getMoney() < this.Math.round(bros.len() * 5 * this.m.Settlement.getBuyPriceMult()))
		{
			return null;
		}

		this.Sound.play(this.Const.Sound.TavernRound[this.Math.rand(0, this.Const.Sound.TavernRound.len() - 1)]);
		this.World.Assets.addMoney(this.Math.round(bros.len() * -5 * this.m.Settlement.getBuyPriceMult()));
		++this.m.RoundsGiven;
		this.m.LastRoundTime = this.Time.getVirtualTimeF();
		local result = {
			Intro = this.Const.Strings.PayTavernRoundIntro[this.Math.rand(0, this.Const.Strings.PayTavernRoundIntro.len() - 1)],
			Result = []
		};

		foreach( b in bros )
		{
			if (result.Result.len() >= 5)
			{
				break;
			}

			local drunkChance = (this.m.RoundsGiven - 1) * 10;

			if (!b.getSkills().hasSkill("effects.drunk"))
			{
				if (b.getSkills().hasSkill("trait.drunkard"))
				{
					drunkChance = drunkChance + 20;
				}

				if (b.getSkills().hasSkill("trait.strong"))
				{
					drunkChance = drunkChance - 10;
				}

				if (b.getSkills().hasSkill("trait.tough"))
				{
					drunkChance = drunkChance - 10;
				}

				if (b.getSkills().hasSkill("trait.fragile"))
				{
					drunkChance = drunkChance + 10;
				}

				if (b.getSkills().hasSkill("trait.tiny"))
				{
					drunkChance = drunkChance + 10;
				}

				if (b.getSkills().hasSkill("trait.bright"))
				{
					drunkChance = drunkChance - 10;
				}
				else if (b.getSkills().hasSkill("trait.dumb"))
				{
					drunkChance = drunkChance + 10;
				}
			}
			else
			{
				drunkChance = 0;
			}

			if (this.Math.rand(1, 100) <= drunkChance)
			{
				local drunk = this.new("scripts/skills/effects_world/drunk_effect");
				b.getSkills().add(drunk);
				result.Result.push({
					Icon = drunk.getIcon(),
					Text = b.getName() + " is now drunk."
				});
			}

			if ((b.getLastDrinkTime() == 0 || this.Time.getVirtualTimeF() - b.getLastDrinkTime() > this.World.getTime().SecondsPerDay) && this.Math.rand(1, 100) <= 35)
			{
				b.setLastDrinkTime(this.Time.getVirtualTimeF());
				b.improveMood(this.Const.MoodChange.DrunkAtTavern, "Got drunk with the company");
				result.Result.push({
					Icon = this.Const.MoodStateIcon[b.getMoodState()],
					Text = b.getName() + this.Const.MoodStateEvent[b.getMoodState()]
				});
			}
		}

		return result;
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
		_out.writeU8(this.m.RumorsGiven);
		_out.writeU8(this.m.RoundsGiven);
		_out.writeF32(this.m.LastRumorTime);
		_out.writeF32(this.m.LastRoundTime);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
		this.m.RumorsGiven = _in.readU8();
		this.m.RoundsGiven = _in.readU8();
		this.m.LastRumorTime = _in.readF32();
		this.m.LastRoundTime = _in.readF32();
	}

});

