this.killer_vs_others_event <- this.inherit("scripts/events/event", {
	m = {
		Killer = null,
		OtherGuy1 = null,
		OtherGuy2 = null
	},
	function create()
	{
		this.m.ID = "event.killer_vs_others";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]While you attempt to study some poorly drawn maps, the sound of blades being drawn pierces your ears. You roll up your work and put it into a scroll\'s sleeve before making way to the disturbance.\n\n%killerontherun% is being held down by one brother\'s knee, while %otherguy1% and %otherguy2% look about ready to chop his head off. Seeing your arrival, the men calm down for a moment. They explain that the killer tried to slay one of them. Indeed, the brother has a nick on his neck. A little bit deeper and something other than words would be coming out of his mouth right about now. The men demand %killerontherun% be hanged for this attempted murder.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Have him flogged for this.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Have him hanged for this.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "This is your family now. Do not ever dare such a thing again!",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 3);

						if (r == 1)
						{
							return "D";
						}
						else if (r == 2)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_38.png[/img]You order the man flogged. %killerontherun% spits on your name as the brothers tie him up to a tree. You say do that again and you\'ll add more lashings. They rip his shirt off and take turns with the whip as you stand by the side, counting. On the first lash a straight line of skin is stripped from his back. The man flinches and you hear the ropes that bind him draw taut as his hands clench into fists. By the fifth lashing he is no longer standing. By the tenth he is no longer awake. After five more you call it and order the men to take him down and tend his wounds.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I hope this is a lesson learned.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.Killer.addLightInjury();
				_event.m.Killer.worsenMood(3.0, "Was flogged on your orders");
				this.List = [
					{
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Killer.getName() + " suffers light wounds"
					}
				];

				if (_event.m.Killer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_02.png[/img]You order the man hanged. Half the company cheers and %killerontherun% screams a shriek rather suitable for seeing death ordered to his side. They drag the man beneath a tree. Ropes are thrown up over the branches, again and again, looping and drawing taut. One man ties a noose while the others cheer and clap and drink beer. A stool is placed and the condemned man is forced to stand on it. As %killerontherun%\'s head is put into the noose, he says he has a word for all of you, but whatever he has to say is cut off when %otherguy1% kicks the stool out from beneath him.\n\nThis is not a good way to die. It is by an executioner\'s hand or means. Ordinarily a man dropped from a platform breaks his neck, or is even decapitated. This man hangs choking and kicking. You hear some screams in his lungs, but they struggle to get past his throat. A few minutes pass and he is still fighting. %otherguy2% steps over to the dying man, grabbing one of his jerking feet to keep him still, and with his free hand he stabs %killerontherun% in the heart. And that was that.\n\n{Surprisingly, the brothers agree to cut the man down and bury him. | The man is left hanging there when the company\'s march begins anew.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We march on.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Killer.getName() + " has died"
				});
				_event.m.Killer.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Killer);
				_event.m.OtherGuy1.improveMood(2.0, "Got satisfaction with " + _event.m.Killer.getNameOnly() + "\'s hanging");

				if (_event.m.OtherGuy1.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.OtherGuy1.getMoodState()],
						text = _event.m.OtherGuy1.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy1.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]While you try to bring peace between a party of misfits, your attempts for neutrality only seem to anger a few of the men. In particular, the man with the nicked neck is seething, swearing and kicking things over. A few of the other men worry aloud about a lack of discipline.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We march on.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.OtherGuy1.worsenMood(4.0, "Angry about lack of justice under your command");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.OtherGuy1.getMoodState()],
					text = _event.m.OtherGuy1.getName() + this.Const.MoodStateEvent[_event.m.OtherGuy1.getMoodState()]
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Killer.getID() || bro.getID() == _event.m.OtherGuy1.getID())
					{
						continue;
					}

					bro.worsenMood(1.0, "Concerned about lack of discipline");

					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getNameOnly() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_64.png[/img]The call for cooler heads to prevail seems to have failed as %killerontherun%\'s body is found dead anyway. {It appears someone stabbed him in the back. | Someone garroted the man with a line of strong linen. | He was nearly chopped in half, the work of a truly angry person. | His head was found resting on his chest, his hands placed in such a manner as to be holding it. | Emphasis on the word \'body\', as his head was nowhere to be found. | Someone had slit his throat in the night. | Bruises on his body and cuts on his hands suggests a fight, but whoever it was managed to gut the man anyway.} You have a good guess as to who did it, but none of the men seem all that upset about the man\'s death and certain proof would elude any kind of investigation. While all of that may be true, you still order the suspected brother to help bury the dead.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nothing to be done now.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				local dead = _event.m.Killer;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Murdered by his fellow brothers",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Killer.getName() + " has died"
				});
				_event.m.Killer.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Killer);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.OtherGuy1.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						continue;
					}

					bro.worsenMood(1.0, "Concerned about lack of discipline");

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

		});
		this.m.Screens.push({
			ID = "F",
			Text = "Well, %killerontherun% isn\'t dead, but he stands before you broken and beaten. It looks like vengeful justice found him out anyway. He demands that some suspected brothers be punished for going around your orders. You consider this, but then ask the man what will happen if you continue this cycle of violence. It\'s hard to see the man\'s face as it is puffed up in blacks and purples, and his eyes are lost behind puckered lids, but he nods gingerly. You are right, he says. It is best to let this whole thing die down lest it get out of control.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We march on.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.OtherGuy1.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
				local injury = _event.m.Killer.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 13,
					icon = injury.getIcon(),
					text = _event.m.Killer.getName() + " suffers " + injury.getNameOnly()
				});
				injury = _event.m.Killer.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 13,
					icon = injury.getIcon(),
					text = _event.m.Killer.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Killer.worsenMood(2.0, "Was beaten up by men of the company");

				if (_event.m.Killer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Killer.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50 && bro.getID() != _event.m.OtherGuy1.getID())
					{
						continue;
					}

					bro.worsenMood(1.0, "Concerned about lack of discipline");

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

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local killer_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getHireTime() + this.World.getTime().SecondsPerDay * 60 >= this.World.getTime().Time && bro.getBackground().getID() == "background.killer_on_the_run" && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				killer_candidates.push(bro);
			}
		}

		if (killer_candidates.len() == 0)
		{
			return;
		}

		this.m.Killer = killer_candidates[this.Math.rand(0, killer_candidates.len() - 1)];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Killer.getID() && bro.getBackground().getID() != "background.slave")
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy1 = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Killer.getID() && bro.getID() != this.m.OtherGuy1.getID())
			{
				other_candidates.push(bro);
			}
		}

		if (other_candidates.len() == 0)
		{
			return;
		}

		this.m.OtherGuy2 = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"killerontherun",
			this.m.Killer.getName()
		]);
		_vars.push([
			"otherguy1",
			this.m.OtherGuy1.getName()
		]);
		_vars.push([
			"otherguy2",
			this.m.OtherGuy2.getName()
		]);
	}

	function onClear()
	{
		this.m.Killer = null;
		this.m.OtherGuy1 = null;
		this.m.OtherGuy2 = null;
	}

});

