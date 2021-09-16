this.cultist_origin_sacrifice_event <- this.inherit("scripts/events/event", {
	m = {
		Sacrifice = null,
		Sacrifice1 = null,
		Sacrifice2 = null,
		LastTriggeredOnDay = 0
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_sacrifice";
		this.m.Title = "During camp...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_140.png[/img]{Most would consider the dream to have been a nightmare: the darkness surrounded you, a black so flat you could reach out and touch it. The voice spoke a language you\'d never heard before, and yet you understood it nonetheless. Two faces emerged for the infinite shade: %sac1% and %sac2%. The men seemed so close, yet when you reached out they shrank, as though your fingers stretched infinitely into the void.\n\n Upon waking, you knew what must be done. But a trust had been put in you here, a trust by Davkul. A trust to do what few men can: make a choice. | Davkul\'s presence arrived during a campfire. The rest of the men faded into the aether of infinite black, and a strange entity replaced them. An entity which you could not see, but whose presence was but a penumbra of crossing shadows. It requested a sacrifice, not by speaking to you, but by showing: %sac1% and %sac2%. First one melted away before revivifying, then the other repeated the process until both existed with their hands out and eyes closed. It was clear that Davkul was trusting you with a choice. \n\n When the shadows snapped away, the campfire was blinding. %sac1% and %sac2% were staring at you.%SPEECH_ON%Is all alright, sir?%SPEECH_OFF% | You traveled to the place. You knew you were sleeping, but you knew damn well you traveled there nonetheless, shifting beyond your mind, beyond your body, coursing over the earth, over its rivers, across its dry earth, and past the mountains which would crumble. There you found Davkul, the immutable darkness, the inviting shade.\n\n %sac1% and %sac2% were already there, standing closest to you and Davkul\'s shape shifted restlessly behind their images. A black hand of fog pushed one man forward and then yanked him back, then repeated it with the other man. You nodded in understanding. A sacrifice was required and you were to choose.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%sac1% will have the honor to meet Davkul.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice1;
						return "B";
					}

				},
				{
					Text = "%sac2% will have the honor to meet Davkul.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice2;
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice1.getImagePath());
				this.Characters.push(_event.m.Sacrifice2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_140.png[/img]{%sacrifice% is bound and put to the fire. The smell of burnt pork fills the air and the men around you rejoice with tears in their eyes. You see a face twisting in the smoke of the sacrifice, a knowing visage that approves. The men are emboldened. | %sacrifice% is chopped to pieces until he is but a torso and head. The blood has emptied across the ground and yet there\'s still light in his eyes and a perverse smile upon his face. You take an axehead and run it into his throat until he is no more. Every bodypart is separated and put upon a pole, caked in grease, and lit aflame. You and the men dance beneath the pyres as the night comes and the night goes. | The procession is such: %sacrifice% is flayed alive and pierced with sharpened sticks through each limb and held aloft, spread-eagled over a fire which cooks him until death. The men watch his passing in silence, but as soon as one of his charred limbs breaks and collapses his corpse into the flames the men cheer and hoot and holler, some pray, others roll around in the ashes of %sacrifice%, some licking it off their fingertips like it were sweets. It is a good night. | A long stick is pierced through %sacrifice% from posterior to out the side of his neck. He is tilted up into the sky and held there by one man while others use long spears to stab him through until his corpse is the apex of an uncovered tent. The conical corpse is then covered with grass and mud until there stands a tipi, a torso and head of %sacrifice% all that remains above, and should you enter the tent you would find his legs dangling from its ceiling. The monument should stand as an omen for those to come, and a sign that they should come to accept that which awaits us all.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A reminder for us all.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice.getImagePath());
				local dead = _event.m.Sacrifice;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Sacrificed to Davkul",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " has died"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				local brothers = this.World.getPlayerRoster().getAll();
				local hasProphet = false;

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.cultist_prophet"))
					{
						hasProphet = true;
						break;
					}
				}

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "Appeased Davkul");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

						for( ; this.Math.rand(1, 100) > 50;  )
						{
						}

						local skills = bro.getSkills();
						local skill;

						if (skills.hasSkill("trait.cultist_prophet"))
						{
							continue;
						}
						else if (skills.hasSkill("trait.cultist_chosen"))
						{
							if (hasProphet)
							{
								continue;
							}

							hasProphet = true;
							this.updateAchievement("VoiceOfDavkul", 1, 1);
							skills.removeByID("trait.cultist_chosen");
							skill = this.new("scripts/skills/actives/voice_of_davkul_skill");
							skills.add(skill);
							skill = this.new("scripts/skills/traits/cultist_prophet_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_disciple"))
						{
							skills.removeByID("trait.cultist_disciple");
							skill = this.new("scripts/skills/traits/cultist_chosen_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_acolyte"))
						{
							skills.removeByID("trait.cultist_acolyte");
							skill = this.new("scripts/skills/traits/cultist_disciple_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_zealot"))
						{
							skills.removeByID("trait.cultist_zealot");
							skill = this.new("scripts/skills/traits/cultist_acolyte_trait");
							skills.add(skill);
						}
						else if (skills.hasSkill("trait.cultist_fanatic"))
						{
							skills.removeByID("trait.cultist_fanatic");
							skill = this.new("scripts/skills/traits/cultist_zealot_trait");
							skills.add(skill);
						}
						else
						{
							skill = this.new("scripts/skills/traits/cultist_fanatic_trait");
							skills.add(skill);
						}

						if (skill != null)
						{
							this.List.push({
								id = 10,
								icon = skill.getIcon(),
								text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
							});
						}
					}
					else if (!bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(4.0, "Horrified by the sacrifice of " + _event.m.Sacrifice.getName());

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().Days <= 5)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		brothers.sort(function ( _a, _b )
		{
			if (_a.getXP() < _b.getXP())
			{
				return -1;
			}
			else if (_a.getXP() > _b.getXP())
			{
				return 1;
			}

			return 0;
		});
		local r = this.Math.rand(0, this.Math.min(2, brothers.len() - 1));
		this.m.Sacrifice1 = brothers[r];
		brothers.remove(r);
		r = this.Math.rand(0, this.Math.min(2, brothers.len() - 1));
		this.m.Sacrifice2 = brothers[r];
		this.m.Score = 50 + (this.World.getTime().Days - this.m.LastTriggeredOnDay);
	}

	function onPrepare()
	{
		this.m.LastTriggeredOnDay = this.World.getTime().Days;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sac1",
			this.m.Sacrifice1.getName()
		]);
		_vars.push([
			"sac2",
			this.m.Sacrifice2.getName()
		]);
		_vars.push([
			"sacrifice",
			this.m.Sacrifice != null ? this.m.Sacrifice.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Sacrifice1 = null;
		this.m.Sacrifice2 = null;
		this.m.Sacrifice = null;
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU16(this.m.LastTriggeredOnDay);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 62)
		{
			this.m.LastTriggeredOnDay = _in.readU16();
		}
	}

});

