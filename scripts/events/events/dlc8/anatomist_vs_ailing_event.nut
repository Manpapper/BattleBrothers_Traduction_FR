this.anatomist_vs_ailing_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Ailing = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_ailing";
		this.m.Title = "During camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%ailing% the ailing sellsword is curled up and staring into the campfire. He\'s been ill for a while and does not seem to be getting any better. However, %anatomist% the anatomist suggests that he might be able to concoct a solution for the man, a sort of potion that he can imbibe to strengthen his body and heal himself.%SPEECH_ON%I\'ve seen it work many a time. Now, there is an issue: the required ingredients are not native to where we are, but I\'ve read enough on the subject that I can find suitable substitutes with ease.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Go and and heal him of his ailments.",
					function getResult( _event )
					{
						local outcome = this.Math.rand(1, 100);

						if (outcome <= 33)
						{
							return "B";
						}
						else if (outcome <= 66)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "No, this doesn\'t sound safe at all.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You let %anatomist% do his work, whatever that is. The anatomist and %ailing% disappear into a tent for awhile. By the time it is ready for the company to get back on the road, %ailing% is a new man. He is revivified with newfound energies, and he has a certain spring in his step. %anatomist% comes out writing notes in his book.%SPEECH_ON%Results were quite good, quite good indeed.%SPEECH_OFF%Curious, you ask him what he did. He snaps out of his focus and glares up at you, then turns the book away so you cannot read it. He continues murmuring to himself.%SPEECH_ON%Best results? No, I cannot write best results. He might yet still suffer effects which might come in a little, how do I put this, sideways.%SPEECH_OFF%Well. Hopefully %ailing% is merely healed and that\'s that.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road then.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_59.png",
						text = _event.m.Ailing.getName() + " is no longer Ailing"
					}
				];
				local healthBoost = this.Math.rand(2, 4);
				_event.m.Ailing.getBaseProperties().Hitpoints += healthBoost;
				_event.m.Ailing.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Ailing.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + healthBoost + "[/color] Hitpoints"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You give %anatomist% the go ahead. He and %ailing% step away for a time, going into a tent together. Hours pass and the company should get back on the road soon. You walk over and enter the tent. %ailing% is on a cot with his arms crossed over his head and his legs bowed at the knees. He\'s covered in sweat and keeps turning his head from left to right. %anatomist% is at his side taking notes.%SPEECH_ON%It appears the procedure did not work as intended, however even unintended consequences can carry information of great import.%SPEECH_OFF%Furious, you ask if the man is going to make it. The anatomist nods.%SPEECH_ON%He might suffer some delusions for a while, but ultimately he will still be a breathing animal-excuse me, a breathing man.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s just get on the road then.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.Ailing.getName() + " is no longer Ailing"
				});

				if (!_event.m.Ailing.getSkills().hasSkill("trait.paranoid"))
				{
					local trait = this.new("scripts/skills/traits/paranoid_trait");
					_event.m.Ailing.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Ailing.getName() + " gains Paranoid"
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You decide to let the anatomist do what he needs to with the hope that %ailing% will make a speedy recovery. As time goes on, you need to get the company back on the road and %anatomist% still hasn\'t come out of the tent. You go over and peek in.\n\nYou find the anatomist sitting on a stool off to the side. He has one arm slung across a table with the hand scratching back and forth in mad notetaking. His other arm is slack between his legs, his thumb and finger pressing together now and again in a strange pinching motion that seems to be counting the seconds. You take your eyes to %ailing% who is sitting up on a cot, his legs over the sides and his feet on the ground. He looks up at you.%SPEECH_ON%Hey there, captain, I think I\'m feeling much better now. Much, much better. Ready to...take on the world.%SPEECH_OFF%The man springs to his feet and pounds his chest, yet his voice does not rise.%SPEECH_ON%Shall we resume the road?%SPEECH_OFF%He walks out of the tent and the second the tarp flaps closed, %anatomist% stops writing and sets down his quill pen. He nods.%SPEECH_ON%The procedure was a success. He is no longer ill. He is healed and then some.%SPEECH_OFF%And then some? That\'s not the sort of language you really want to see right now. You\'ll have to keep an eye on the man to see what exactly has changed about him.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "No more experiments, anatomist.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Ailing.getSkills().removeByID("trait.ailing");
				this.List.push({
					id = 10,
					icon = "ui/traits/trait_icon_59.png",
					text = _event.m.Ailing.getName() + " is no longer Ailing"
				});
				local new_traits = [
					"scripts/skills/traits/bloodthirsty_trait",
					"scripts/skills/traits/brute_trait",
					"scripts/skills/traits/cocky_trait",
					"scripts/skills/traits/deathwish_trait",
					"scripts/skills/traits/dumb_trait",
					"scripts/skills/traits/gluttonous_trait",
					"scripts/skills/traits/impatient_trait",
					"scripts/skills/traits/irrational_trait",
					"scripts/skills/traits/paranoid_trait",
					"scripts/skills/traits/spartan_trait",
					"scripts/skills/traits/superstitious_trait"
				];
				local num_new_traits = 2;

				while (num_new_traits > 0 && new_traits.len() > 0)
				{
					local trait = this.new(new_traits.remove(this.Math.rand(0, new_traits.len() - 1)));

					if (!_event.m.Ailing.getSkills().hasSkill(trait.getID()))
					{
						_event.m.Ailing.getSkills().add(trait);
						this.List.push({
							id = 10,
							icon = trait.getIcon(),
							text = _event.m.Ailing.getName() + " gains " + trait.getName()
						});
						num_new_traits = num_new_traits - 1;
					}
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Ailing.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You tell %anatomist% no. %ailing% is strong enough to heal on his own. The anatomist sighs. You get a sense that he had no real interest in helping the sellsword, only an interest in experimenting on him.%SPEECH_ON%Great advances can only be made with great risks, captain.%SPEECH_OFF%He says before walking off, his quill pen scratching out a name on one of his tomes.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "About to advance my fist into your...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local ailingCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.ailing"))
			{
				ailingCandidates.push(bro);
			}
		}

		if (ailingCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Ailing = ailingCandidates[this.Math.rand(0, ailingCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * ailingCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"ailing",
			this.m.Ailing.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Ailing = null;
	}

});

