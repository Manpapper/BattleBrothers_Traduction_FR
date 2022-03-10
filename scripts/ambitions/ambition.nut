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
		IsCancelable = true,
		IsRepeatable = false,
		Score = 0,
		TimesSkipped = 0
	},
	function getID()
	{
		return this.m.ID;
	}

	function getScore()
	{
		return this.m.Score;
	}

	function getTimesSkipped()
	{
		return this.m.TimesSkipped;
	}
	function getButtonText()
	{
		return this.m.ButtonText;
	}

	function getRewardTooltip()
	{
		return this.m.RewardTooltip;
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

	function isCancelable()
	{
		return this.m.IsCancelable;
	}

	function isRepeatable()
	{
		return this.m.IsRepeatable;
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
			text = "Votre Renom augmentera, ce qui signifie une meilleure paie pour les contrats et potentiellement débloquera de nouveaux types de contrats."
		});
		return ret;
	}
	
	function getRenownOnSuccess()
	{
		return this.Const.World.Assets.ReputationOnAmbition;
	}

	function create()
	{
	}

	function update()
	{
		this.clear();

		if (this.m.IsDone && !this.m.IsRepeatable || this.Time.getVirtualTimeF() < this.m.CooldownUntil)
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
			this.World.Assets.addBusinessReputation(this.getRenownOnSuccess());
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
	
	function skip()
	{
		this.m.TimesSkipped++;
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
	
	function onUpdateEffect()
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
		_out.writeBool(this.m.IsCancelable);
		_out.writeBool(this.m.IsRepeatable);
		_out.writeU32(this.m.TimesSkipped);
	}
	
	function onDeserialize( _in )
	{
		this.m.StartTime = _in.readF32();
		this.m.CooldownUntil = _in.readF32();
		this.m.IsDone = _in.readBool();

		if (_in.getMetaData().getVersion() >= 64)
		{
			this.m.IsCancelable = _in.readBool();
			this.m.IsRepeatable = _in.readBool();
			this.m.TimesSkipped = _in.readU32();
		}
	}
};

