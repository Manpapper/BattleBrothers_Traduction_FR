this.how_far_is_the_sun_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Monk = null,
		Cultist = null,
		Archer = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.how_far_is_the_sun";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]While resting, the men start a conversation about how far away the sun is. %otherbrother% looks up at it, wincing and gritting his teeth as he just about blinds himself in his measuring. Finally, he looks back down.%SPEECH_ON%I\'d wager it\'s about ten to fifteen miles away.%SPEECH_OFF%He nods at his own presumably accurate summation.%SPEECH_ON%Aye, probably not even that far. I heard a story about an archer in a faraway land hitting it with an arrow.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Historian != null)
				{
					this.Options.push({
						Text = "%historianfull%, what have you to say?",
						function getResult( _event )
						{
							return "Historian";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "I bet %monkfull% knows the truth.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "I see you thinking, %cultistfull%. What say you?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "%archerfull%, why don\'t you take a shot?",
						function getResult( _event )
						{
							return "Archer";
						}

					});
				}

				this.Options.push({
					Text = "Enough star talk. Back to the road.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Historian",
			Text = "[img]gfx/ui/events/event_05.png[/img]%historian% the historian starts in on the conversation.%SPEECH_ON%I doubt the veracity of that claim about shooting it with a bow. Here\'s a much more truthful tale I\'ve read of: there are men in the mountains of the east who have big spyglasses to stare up at the night sky. They think the sun is quite far away. At least ten thousand miles, even. They also think the nightlights are other suns and not the souls of dead heroes.%SPEECH_OFF%%otherbrother% gets up.%SPEECH_ON%Watch yer mouth, fool, and don\'t speak ill of our ancestors.%SPEECH_OFF%The historian nods.%SPEECH_ON%Of course! It was only an idea.%SPEECH_OFF%What hogwash. Pretty dumb shite for a supposed \'smart\' man like %historian%. A few of the brothers have a laugh at the historian\'s silly notions.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a laugh riot he is.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Historian.getID() || bro.getBackground().getID() == "background.historian" || bro.getSkills().hasSkill("trait.bright"))
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Entertained by " + _event.m.Historian.getName() + "\'s silly notions about the sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_05.png[/img]%monk% the monk starts in on the conversation.%SPEECH_ON%The sun is neither far nor close. It is the eye of many of the gods, the scope through which they use to watch over us.%SPEECH_OFF%%otherbrother% nods, but then, curious, asks about the moon. The monk smiles confidently.%SPEECH_ON%Do you think the gods would shine upon us for all hours? Of course they dim the lights a bit, to give us mortals a nice night to sleep in.%SPEECH_OFF%You nod. Truly the old gods are always looking out for us.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bless them.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 1 || bro.getID() == _event.m.Monk.getID() || bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist" || bro.getBackground().getID() == "background.historian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Encouraged by " + _event.m.Monk.getName() + "\'s preaching");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		this.m.Screens.push({
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_05.png[/img]%cultist% the cultist gets up and looks at the sun. As he continues to stare at it, a shadow slowly emerges over his face, as though some entity were shielding him from the light. Suddenly, he raises a hand and starts drawing some aerial rites with his hand. You swear the darkness on his face is moving as though an imprint of his drawings, a sort of shifting tattoo. When he\'s finished, he takes a seat.%SPEECH_ON%The sun is dying.%SPEECH_OFF%The men look concerned. One interjects.%SPEECH_ON%Dying? What do you mean?%SPEECH_OFF%%cultist% stares at him.%SPEECH_ON%Davkul wills it that all may die.%SPEECH_OFF%One man asks if this supposed \'Davkul\' will die too. The cultist nods.%SPEECH_ON%When there is nothing left to die, Davkul may finally rest. A crueler god would have departed already. It is by Davkul\'s good graces that he will go last, and for that we praise him.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Errr, right.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Cultist.getID())
					{
						bro.improveMood(1.0, "Relished the opportunity to talk about the dying sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().getID() == "background.cultist")
					{
						bro.improveMood(0.5, "Relished " + _event.m.Cultist.getName() + "\'s speech about the dying sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1)
					{
						bro.worsenMood(1.0, "Angry about the heretical ramblings of " + _event.m.Cultist.getName());

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(1.0, "Terrified at the prospect of a dying sun");

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
		this.m.Screens.push({
			ID = "Archer",
			Text = "[img]gfx/ui/events/event_05.png[/img]%archer% takes the challenge, grabbing his bow and a couple of arrows. He licks his finger and holds it up.%SPEECH_ON%Wind\'s right for a good star shootin\'.%SPEECH_OFF%The archer nocks an arrow, draws, and takes aim. The blistering light is instantly blinding.%SPEECH_ON%Fark, I can\'t see shit.%SPEECH_OFF%His aim wobbles as dark spots take over his vision. The arrow is loosed and sails wide of the sun. Real wide. He looks at the company, eyes dimmed, hands out as he tries to steady himself while his sight returns.%SPEECH_ON%Did I hit it?%SPEECH_OFF%%otherbrother% hides his chuckling.%SPEECH_ON%Right on the button!%SPEECH_OFF%The men burst into laughter.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good shot, sir!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Entertained by " + _event.m.Archer.getName() + "\'s attempt to shoot the sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_historian = [];
		local candidate_monk = [];
		local candidate_cultist = [];
		local candidate_archer = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				candidate_historian.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidate_cultist.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword")
			{
				candidate_archer.push(bro);
			}
			else if (bro.getEthnicity() != 1 && bro.getBackground().getID() != "background.slave")
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		local options = 0;

		if (candidate_historian.len() != 0)
		{
			options = ++options;
		}

		if (candidate_monk.len() != 0)
		{
			options = ++options;
		}

		if (candidate_cultist.len() != 0)
		{
			options = ++options;
		}

		if (candidate_archer.len() != 0)
		{
			options = ++options;
		}

		if (options < 2)
		{
			return;
		}

		if (candidate_historian.len() != 0)
		{
			this.m.Historian = candidate_historian[this.Math.rand(0, candidate_historian.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_cultist.len() != 0)
		{
			this.m.Cultist = candidate_cultist[this.Math.rand(0, candidate_cultist.len() - 1)];
		}

		if (candidate_archer.len() != 0)
		{
			this.m.Archer = candidate_archer[this.Math.rand(0, candidate_archer.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = options * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"historianfull",
			this.m.Historian != null ? this.m.Historian.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"cultistfull",
			this.m.Cultist != null ? this.m.Cultist.getName() : ""
		]);
		_vars.push([
			"archer",
			this.m.Archer != null ? this.m.Archer.getNameOnly() : ""
		]);
		_vars.push([
			"archerfull",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Monk = null;
		this.m.Cultist = null;
		this.m.Archer = null;
		this.m.Other = null;
	}

});

