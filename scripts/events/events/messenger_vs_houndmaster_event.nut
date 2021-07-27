this.messenger_vs_houndmaster_event <- this.inherit("scripts/events/event", {
	m = {
		Messenger = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.messenger_vs_houndmaster";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%messenger% and %houndmaster% share stories over a campfire. The messenger laughs.%SPEECH_ON%Lemme tell you about my first delivery. I walked up to this keep that had a nice, beautiful moat. Most dangerous thing in the waters were lily pads and fly-fattened frogs. Walked right over the drawbridge and stepped inside, letter in hand, my belly turning with excitement. I get in there and what do I hear? Roo-roo-roo-roo! Ruh-ruh-ruh! This farkin\' mongrel comes barreling out of its doghouse, teeth bared, ears pinned. I\'m like oh shite, I didn\'t sign up for this and climb a chicken coop while this furred beast tries and eats me feet. Eventually, the lord comes out and the dog sits as though it\'d done nothing at all. The nobleman laughs and takes the letter I came to deliver. He says, \'what, you didn\'t see the sign?\' I said, uh no sir, but I\'ll be going now. When I left, they drew that drawbridge back up and wouldn\'t you know it, on the underside they\'d painted this big \'Beware of Dog\' warning!%SPEECH_OFF%%houndmaster% bursts into laughter.%SPEECH_ON%For your first day on the job, that ain\'t so bad. But I\'ll have you know, no dog of the %companyname% will hurt you! I\'ll train them mutts proper!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Woe is the mailman.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Messenger.getImagePath());
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				_event.m.Messenger.improveMood(1.0, "Bonded with " + _event.m.Houndmaster.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Messenger.getMoodState()],
					text = _event.m.Messenger.getName() + this.Const.MoodStateEvent[_event.m.Messenger.getMoodState()]
				});
				_event.m.Houndmaster.improveMood(1.0, "Bonded with " + _event.m.Messenger.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Houndmaster.getMoodState()],
					text = _event.m.Houndmaster.getName() + this.Const.MoodStateEvent[_event.m.Houndmaster.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local messenger_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.messenger")
			{
				messenger_candidates.push(bro);
			}
		}

		if (messenger_candidates.len() == 0)
		{
			return;
		}

		local houndmaster_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				houndmaster_candidates.push(bro);
			}
		}

		if (houndmaster_candidates.len() == 0)
		{
			return;
		}

		this.m.Messenger = messenger_candidates[this.Math.rand(0, messenger_candidates.len() - 1)];
		this.m.Houndmaster = houndmaster_candidates[this.Math.rand(0, houndmaster_candidates.len() - 1)];
		this.m.Score = (messenger_candidates.len() + houndmaster_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"messenger",
			this.m.Messenger.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Messenger = null;
		this.m.Houndmaster = null;
	}

});

