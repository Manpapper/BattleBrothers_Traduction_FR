this.anatomist_vs_iron_lungs_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		IronLungs = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_ironlungs";
		this.m.Title = "During camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Having great stamina is quite important in the world of sellswording, but it is clear that some men are far more capable of combating fatigue than others. %ironlungs% is one such man, a fighter notorious for keeping steady breath long into a grueling battle. To you, this is nothing more than something of a curiosity, like when a man has a weird neck, huge hands, or a big hammer between his legs. But to %anatomist%, it\'s something else entirely. He wishes to know how exactly one man can have such sturdy and powerful lungs when his day-to-day life is of little difference compared to those around him.%SPEECH_ON%We\'re all fighters here, so how did it come to pass that this man can breathe at such a steady rate compared to the rest of us? Surely he contains an element that we do not, and I think I may be able to find that element.%SPEECH_OFF%Wait, \'we\' are all fighters here? You wouldn\'t quite go that far, but you don\'t correct the anatomist. You ask him how exactly he\'d study this matter.%SPEECH_ON%A simple dissection would not be a digression, all things considered, but I believe that %ironlungs% would refuse the request. So, that leaves me with one options, which is to study him intently and see if I can replicate his strengths unto myself through bone manipulation and careful incisions.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hey, it\'s your body.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "Not a chance.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You tell the anatomist to go on doing whatever he wants to do. He takes out a quill pen and some books, and then follows that up with a pannier filled with metal tongs and scissors and scalpels. He checks them each for cleanliness, then lofts them up and goes over to %ironlungs%. The sellsword responds with awkward stares. Eventually, the anatomist convinces the man to step into a tent with him. You keep an eye on the area in case the anatomist loses it and goes into a mad egghead rampage. Eventually, %anatomist% returns with a vial in hand which he swirls around for a time, then drinks. He nods.%SPEECH_ON%Hopefully this may work. I took great strains to my own body, to really stress the lungs, followed by some ingredients courtesy of %ironlungs% himself. Then, naturally, additional elements which I shall not divulge to anyone, ever, for if this works I may yet be the expert in its field, a true hero to the sciences, and absolutely have one up and over other anatomists.%SPEECH_OFF%Alright. %ironlungs% appears from the tent now. You ask him what all happened. The man shrugs.%SPEECH_ON%I told him that I stretch a lot and have good posture, and that I do practice my breathing now and again. He refused these answers, convincing himself there must be some other way. Then he went full on nutbar with the tools he had and started, uh, \'working\' on himself. Whatever he did looked mighty painful, but he took it in stride.%SPEECH_OFF%Wait, you practice your breathing?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I am now breathing manually.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local trait = this.new("scripts/skills/traits/iron_lungs_trait");
				_event.m.Anatomist.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Anatomist.getName() + " gains Iron Lungs"
				});
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 11,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%anatomist% is given the go ahead and he hurriedly retreats to his tent with a bag of tools and %ironlungs% in tow. You wander into the tent to find %anatomist% sitting upright with immaculate posture, and he then bends like an old man with a spine crumpled from old age, then straight again.\n\nSuddenly, he takes one of his tools and punctures himself with it. %ironlungs% reels backward, a bit shocked at such a self-destructive act. He reaches out to help the anatomist, but the man waves him off. Gritting his teeth, %anatomist% starts writing notes as blood spits out of his mouth and onto the pages. Then he repeats the process again, this time from another angle.\n\nEven from a distance you can now see the blood pumping out in ropes of dark red, then now and again spraying in bright crimson. He grits his teeth and commits to another strike. This time a great gush of red spews out. You\'ve seen enough, but before you can finally intervene the anatomist\'s eyes roll to the back of his head and he passes out %ironlungs% looks shocked.%SPEECH_ON%What the fark? Did you okay this, captain? What did he hope to learn?%SPEECH_OFF%You don\'t get paid enough to put with these morons. Looking at the anatomist\'s notes, you can see through the bloodied page that he simply wrote \'not working\' again and again.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "When just breathing makes you a dull boy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.pierced_lung",
						Threshold = 0.0,
						Script = "injury/pierced_lung_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Anatomist.worsenMood(0.5, "His experimental surgery didn\'t work");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.IronLungs.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You tell the anatomist to mind his own business. When he puts up a fuss, which is getting dangerously close to making it your business, you tell him that %ironlungs% is his own man, and wholly his own, and that there\'s nothing to be taken from his existence aside from a modicum of admiration. And that\'s that. %anatomist% opens his mouth in response, then closes it. Instead, whatever he was thinking is put down in his notes. You hope any drama behind it dries alongside his ink.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn eggheads.",
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
		local ironLungsCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && !bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() != "background.anatomist" && bro.getSkills().hasSkill("trait.iron_lungs"))
			{
				ironLungsCandidates.push(bro);
			}
		}

		if (ironLungsCandidates.len() == 0 || anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.IronLungs = ironLungsCandidates[this.Math.rand(0, ironLungsCandidates.len() - 1)];
		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 5 * ironLungsCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"ironlungs",
			this.m.IronLungs.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.IronLungs = null;
	}

});

