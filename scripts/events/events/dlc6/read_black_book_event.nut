this.read_black_book_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.read_black_book";
		this.m.Title = "During camp...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{%nonhistorian% enters your tent.%SPEECH_ON%Captain, come quick, there\'s something wrong with %historian%!%SPEECH_OFF%You hurry to the scene. %historian% is bowled over the Lorekeeper\'s book like an ancient man shielding the first flame. He\'s clenching the fleshen covers, hands shaking, and he looks up at you with bloodshot eyes.%SPEECH_ON%I know what it says, captain, I know what it says!%SPEECH_OFF%You crouch down and the man backs off, shaking his head.%SPEECH_ON%No. No! It\'s about the end! The end of all things! We\'re... we\'re merely tools to get there, don\'t you understand? Everything we do, everything anybody does, is a means to the ultimate end: the death of all beings. Our very existence gives it power, without us, it can rest again. But so long as there is existence, it cannot sleep!%SPEECH_OFF%You shake your head and ask what he means. The man turns the book around and there\'s a page that is entirely black, yet he points his finger to a spot on it as though you were meant to read a sentence there.%SPEECH_ON%This is no book, captain, it is instruction, on how to raise the spirits of the dead.%SPEECH_OFF%You ask who could have such knowledge, and %historian% grins madly.%SPEECH_ON%There is no \'who\', there is no \'what\'! It is a tool of undoing, put into this world by the one that calls itself Davkul!%SPEECH_OFF%You tell the men to shelter him as he has clearly lost his mind. One of the sellswords brings you %historian%\'s translations of the book, but they\'re just scribbles, no less unintelligible than their source.%SPEECH_ON%Even if we could understand a word of it, even if we could use it, I don\'t think we should. See, and just between us, but that page he showed you? It had text on it earlier. And I mean in the very moment you were walking up. I could see the words, I could see the symbols. But at some point, the ink, the ash, whatever it was, it spread over the page entirely. It\'s as if we\'re not meant to have this knowledge.%SPEECH_OFF%It\'s quite possible, but there\'s a darker realization spreading over your mind: %historian% is meant to have this knowledge, but his limited understanding is not for your benefit, but merely a tool in the machinations of something else entirely. You are only being shown as much as you need and no more...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "An uneasy thought.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/traits/mad_trait");
				_event.m.Historian.getSkills().add(effect);
				_event.m.Historian.improveMood(2.0, "Has seen the end of things");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Historian.getName() + " has become mad"
				});
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]{%nonhistorian% enters your tent.%SPEECH_ON%Captain, come quick, something happened with %historian%!%SPEECH_OFF%You hurry to the scene. %historian% is bowled over the Lorekeeper\'s book like an ancient man shielding the first flame. He\'s clenching the fleshen covers, hands shaking, and he looks up at you with bloodshot eyes.%SPEECH_ON%I know what it says, captain, I know what it says!%SPEECH_OFF%You crouch down and the man backs off, shaking his head.%SPEECH_ON%No. No! It\'s about the end! The end of all things! We\'re... we\'re merely tools to get there, don\'t you understand? Everything we do, everything anybody does, is a means to the ultimate end: the death of all beings. Our very existence gives it power, without us, it can rest again. But so long as there is existence, it cannot sleep!%SPEECH_OFF%You shake your head and ask what he means. The man turns the book around and there\'s a page that is entirely black, yet he points his finger to a spot on it as though you were meant to read a sentence there.%SPEECH_ON%This is no book, captain, it is instruction, on how to raise the spirits of the dead.%SPEECH_OFF%You ask who could have such knowledge, and %historian% grins madly.%SPEECH_ON%There is no \'who\', there is no \'what\'! It is a tool of undoing, put into this world by Davkul!%SPEECH_OFF%One of the men brings you %historian%\'s translations of the book, but they\'re just scribbles, no less unintelligible than their source.%SPEECH_ON%EJust between us, but that page he showed you? It had text on it earlier. And I mean in the very moment you were walking up. I could see the words, I could see the symbols. But at some point, the ink, the ash, whatever it was, it spread over the page entirely. It\'s as if we\'re not meant to have this knowledge.%SPEECH_OFF%It\'s quite possible, but there\'s a darker realization spreading over your mind: %historian% is meant to have this knowledge, but his limited understanding is not for your benefit, but merely a tool in the machinations of something else entirely. You are only being shown as much as you need and no more...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul awaits us all.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/traits/mad_trait");
				_event.m.Historian.getSkills().add(effect);
				_event.m.Historian.improveMood(2.0, "Has seen the end of things");
				this.List.push({
					id = 10,
					icon = effect.getIcon(),
					text = _event.m.Historian.getName() + " has become mad"
				});
				this.Characters.push(_event.m.Other.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.Flags.get("IsLorekeeperDefeated") || this.World.Flags.get("IsLorekeeperTradeMade"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_historian = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.mad"))
			{
				return;
			}

			if (bro.getBackground().getID() == "background.historian" && bro.getLevel() >= 2 || bro.getBackground().getID() == "background.cultist" && bro.getLevel() >= 9)
			{
				candidates_historian.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_historian.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local hasBlackBook = false;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.black_book")
			{
				hasBlackBook = true;
				break;
			}
		}

		if (!hasBlackBook)
		{
			return;
		}

		this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getName()
		]);
		_vars.push([
			"nonhistorian",
			this.m.Other.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
		{
			return "B";
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Other = null;
	}

});

