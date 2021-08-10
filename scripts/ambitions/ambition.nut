this.ambition <- {
	m = {
		ID = "",
		ButtonText = "",
		TaskTooltip = "",
		RewardTooltip = "",
		UIText = "",
		TooltipText = "",
		SuccessText = "",
		SuccessButtonText = "",
		SuccessList = [],
		Duration = 0.0,
		StartTime = 0.0,
		CooldownUntil = 0.0,
		IsDone = false,
		IsShowingMood = true,
		IsGrantingRenown = true,
		Score = 0
	},
	function getID()
	{
		return this.m.ID;
	}

	function getScore()
	{
		return this.m.Score;
	}

	function getButtonText()
	{
		return this.m.ButtonText;
	}

	function getUIText()
	{
		return this.m.UIText;
	}

	function getTooltipText()
	{
		return this.m.TooltipText;
	}

	function getSuccessText()
	{
		return this.m.SuccessText;
	}

	function getSuccessButtonText()
	{
		return this.m.SuccessButtonText;
	}

	function getSuccessList()
	{
		return this.m.SuccessList;
	}

	function isDone()
	{
		return this.m.IsDone;
	}

	function isShowingMood()
	{
		return this.m.IsShowingMood;
	}

	function isGrantingRenown()
	{
		return this.m.IsGrantingRenown;
	}

	function setDone( _d )
	{
		this.m.IsDone = _d;
	}

	function getButtonTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = "Votre Tâche"
			},
			{
				id = 2,
				type = "text",
				text = this.getTooltipText() + "\n\n"
			},
			{
				id = 4,
				type = "header",
				text = "Votre Récompense"
			}
		];

		if (this.m.RewardTooltip != "")
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/ambition_tooltip.png",
				text = this.m.RewardTooltip
			});
		}

		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/ambition_tooltip.png",
			text = "Votre Renom augmentera, ce qui signifie une meilleure paie pour les contrats et potentiellement débloquer de nouveaux types de contrats."
		});
		return ret;
	}

	function create()
	{
	}

	function update()
	{
		this.clear();

		if (this.m.IsDone || this.Time.getVirtualTimeF() < this.m.CooldownUntil)
		{
			return;
		}

		this.onUpdateScore();
	}

	function clear()
	{
		this.m.Score = 0;
		this.m.SuccessList = [];
		this.onClear();
	}

	function reset()
	{
		this.clear();
		this.m.CooldownUntil = 0;
		this.m.IsDone = false;
	}

	function succeed()
	{
		this.m.IsDone = true;

		if (this.m.IsGrantingRenown)
		{
			this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnAmbition);
		}

		this.onReward();
		this.m.CooldownUntil = this.Time.getVirtualTimeF() + 14.0 * this.World.getTime().SecondsPerDay;
	}

	function fail()
	{
		this.m.CooldownUntil = this.Time.getVirtualTimeF() + 7.0 * this.World.getTime().SecondsPerDay;
	}

	function activate()
	{
		this.m.StartTime = this.Time.getVirtualTimeF();
		this.onStart();
	}

	function isSuccess()
	{
		return this.onCheckSuccess();
	}

	function isFailure()
	{
		return this.Time.getVirtualTimeF() - this.m.StartTime >= this.m.Duration || this.onCheckFailure();
	}

	function onUpdateScore()
	{
	}

	function onClear()
	{
	}

	function onCheckSuccess()
	{
		return false;
	}

	function onCheckFailure()
	{
		return false;
	}

	function onStart()
	{
	}

	function onReward()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onPartyDestroyed( _party )
	{
	}

	function onLocationDestroyed( _location )
	{
	}

	function onLocationDiscovered( _location )
	{
	}

	function onSerialize( _out )
	{
		_out.writeF32(this.m.StartTime);
		_out.writeF32(this.m.CooldownUntil);
		_out.writeBool(this.m.IsDone);
	}

	function onDeserialize( _in )
	{
		this.m.StartTime = _in.readF32();
		this.m.CooldownUntil = _in.readF32();
		this.m.IsDone = _in.readBool();
	}

};

